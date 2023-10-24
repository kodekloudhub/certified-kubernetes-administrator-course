{
    # https://www.linkedin.com/pulse/kubernetes-setup-using-kubeadm-aws-ec2-ubuntu-servers-cedric-wanji/

apt-get update
apt-get install -y apt-transport-https ca-certificates curl jq telnet

cat <<EOF > /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sysctl --system

# Network manager config for calico
mkdir -p /etc/NetworkManager/conf.d/
cat <<EOF > /etc/NetworkManager/conf.d/calico.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
EOF

apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd


KUBE_LATEST=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases | jq -r '.[] | .tag_name'  | sed '/-/!{s/$/_/}' | sort -r -V | sed 's/_$//' | fgrep -v '-' | head -1 | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

crictl config \
        --set runtime-endpoint=unix:///run/containerd/containerd.sock \
        --set image-endpoint=unix:///run/containerd/containerd.sock

[[ "$(hostname)" == controlplane* ]] && kubeadm config images pull

if [ "$(hostname)" == "controlplane01" ]
then
    curl -L https://github.com/projectcalico/calico/releases/download/v3.26.3/calicoctl-linux-amd64 -o calicoctl
    chmod +x ./calicoctl
    mv ./calicoctl /usr/local/bin
fi

}

# control1
{
kubeadm init --control-plane-endpoint $(dig +short loadbalancer):6443 --upload-certs --pod-network-cidr=192.168.0.0/16
kubectl --kubeconfig /etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/tigera-operator.yaml
kubectl --kubeconfig /etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/custom-resources.yaml
}


{
sudo cp /etc/kubernetes/admin.conf .
sudo chmod 666 admin.conf
}



# HAProxy
{
apt-get update
apt-get install -y haproxy
cat <<EOF > /etc/haproxy/haproxy.cfg
frontend kubernetes
    bind $(dig +short loadbalancer):6443
    option tcplog
    mode tcp
    default_backend kubernetes-control-nodes

backend kubernetes-control-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server controlplane01 $(dig +short controlplane01):6443 check fall 3 rise 2
    server controlplane02 $(dig +short controlplane02):6443 check fall 3 rise 2
    server controlplane03 $(dig +short controlplane03):6443 check fall 3 rise 2
EOF

systemctl restart haproxy
}
