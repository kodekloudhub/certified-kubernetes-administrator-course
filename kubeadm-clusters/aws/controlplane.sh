{
    # https://www.linkedin.com/pulse/kubernetes-setup-using-kubeadm-aws-ec2-ubuntu-servers-cedric-wanji/

apt-get update
apt-get install -y apt-transport-https ca-certificates curl jq

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

apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd


KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

crictl config \
        --set runtime-endpoint=unix:///run/containerd/containerd.sock \
        --set image-endpoint=unix:///run/containerd/containerd.sock

}

{
kubeadm init
kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
}

{
sudo cp /etc/kubernetes/admin.conf .
sudo chmod 666 admin.conf
}