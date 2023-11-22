#!/bin/bash
#
# Sets up the kernel with the requirements for running Kubernetes
# Requires a reboot, which is carried out by the vagrant provisioner.
set -ex

# Add br_netfilter kernel module
echo "br_netfilter" >> /etc/modules

# Set network tunables
cat <<EOF >> /etc/sysctl.d/10-kubernetes.conf
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
EOF

