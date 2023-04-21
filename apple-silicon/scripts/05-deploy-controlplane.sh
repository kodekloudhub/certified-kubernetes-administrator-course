#!/usr/bin/env bash

ip=$(ip a | grep enp0s1 | grep inet | awk '{print $2}' | cut -d / -f 1)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$ip

mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config
sudo kubeadm token create --print-join-command | sudo tee /tmp/join-command.sh > /dev/null
sudo chmod +x /tmp/join-command.sh

echo "Installing Weave for pod networking"
kubectl apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"

for s in $(seq 60 -10 10)
do
    echo "Waiting $s seconds for all control plane pods to be running"
    sleep 10
done
