#!/usr/bin/env bash

# Step 4 - Install kubeadm, kubelet and kubectl
KUBE_VERSION=1.26.4

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=${KUBE_VERSION}-00 jq kubectl=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 runc kubernetes-cni=1.2.0-00
sudo apt-mark hold kubelet kubeadm kubectl

