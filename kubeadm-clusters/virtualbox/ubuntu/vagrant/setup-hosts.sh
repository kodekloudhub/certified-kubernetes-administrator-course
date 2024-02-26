#!/bin/bash
#
# Set up /etc/hosts so we can resolve all the machines in the VirtualBox network
set -e
IFNAME=$1
THISHOST=$2
ADDRESS="$(ip route | grep default | awk '{ print $9 }')"
NETWORK=$(echo $ADDRESS | awk 'BEGIN {FS="."} ; { printf("%s.%s.%s", $1, $2, $3) }')
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-jammy entry
sed -e '/^.*ubuntu-jammy.*/d' -i /etc/hosts
sed -e "/^.*$2.*/d" -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
${NETWORK}.11  controlplane
${NETWORK}.21  node01
${NETWORK}.22  node02
EOF

# Export PRIMARY IP as an environment variable
echo "PRIMARY_IP=${ADDRESS}" >> /etc/environment
