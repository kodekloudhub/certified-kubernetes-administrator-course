#!/usr/bin/env bash
#
# This script sets PRIMARY_IP shell variable to the IP
# of the interface used to communicate with the outside world.
# Also provides a script that vagrant can run to obtain this address.

IP_NW=$1
BUILD_MODE=$2
GATEWAY_ADDRESSES=$3

# DISTRO will be "debian" or "rhel"
DISTRO=$(. /etc/os-release ; echo $ID_LIKE | cut -d ' ' -f 1)

logger -p local0.notice -t "setup_host.sh" "IP_NW: ${IP_NW}, BUILD_MODE=${BUILD_MODE}, GATEWAYS=${GATEWAY_ADDRESSES}"

if [ "$BUILD_MODE" = "BRIDGE" ]
then
    # Determine machine IP from route table -
    # Interface that routes to default GW that isn't on the NAT network.
    if [ -z "$GATEWAY_ADDRESSES" ]
    then
        MY_IP="$(ip route | grep default | grep -Pv '10\.\d+\.\d+\.\d+' | awk '{ print $9 }')"
    else
        for g in $(tr ',' '\n' <<< $GATEWAY_ADDRESSES)
        do
            MY_IP="$(ip route | grep default | grep -P $g | awk '{ print $9 }' | head -1)"
            logger -p local0.notice -t "setup_host.sh" "Bridge: GW=$g IF=$MY_IP"
            [ ! -z "$MY_IP" ] && break
        done
    fi

    # From this, determine the network (which for average broadband we assume is a /24)
    MY_NETWORK=$(echo $MY_IP | awk 'BEGIN {FS="."} ; { printf("%s.%s.%s", $1, $2, $3) }')
else
    # Determine machine IP from route table -
    # Interface that is connected to the NAT network.
    # VMware may create 2 entries with different metrics
    MY_IP="$(ip route | awk '/'${IP_NW}'/ { print $9 }' | uniq)"
    MY_NETWORK=$IP_NW
fi

echo "PRIMARY_IP=${MY_IP}" >> /etc/environment

cat <<EOF > /usr/bin/primary-ip
#!/usr/bin/env sh
echo -n $MY_IP
EOF

chmod +x /usr/bin/primary-ip

# Create some other scripts used later in provisioning

scripts=/opt/vagrant

[ -d $scripts ] || mkdir -p $scripts

cat <<EOF > $scripts/update-hosts.sh
#!/usr/bin/env bash
# Idempotent hosts file updater
set -e

err_report() {
  logger -p local0.error -t "update-hosts.sh" "Error at $(caller)"
  exit 1
}

trap err_report ERR

logger -p local0.notice -t "update-hosts.sh" "Updating hosts file"
sed -i '/# BEGIN-VAGRANT/,/# END-VAGRANT/d' /etc/hosts
sed -i "/$(hostname)/d" /etc/hosts
echo "# BEGIN-VAGRANT" >> /etc/hosts
cat /vagrant/hosts.tmp >> /etc/hosts
echo "# END-VAGRANT" >> /etc/hosts
logger -p local0.notice -t "update-hosts.sh" "Done updating hosts file"
EOF

chmod +x $scripts/update-hosts.sh

# Copy config files and scripts to user home dir
for f in tmux.conf vimrc
do
    cp /vagrant/files/$f /home/vagrant/.${f}
    chown vagrant:vagrant /home/vagrant/.${f}
done

f=cert_verify.sh
cp /vagrant/files/$f /home/vagrant/${f}
chown vagrant:vagrant /home/vagrant/${f}
chmod +x /home/vagrant/${f}

# Enable password auth in sshd so we can use ssh-copy-id
sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

