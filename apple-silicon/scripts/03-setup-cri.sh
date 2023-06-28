#!/usr/bin/env bash

# Step 3 - Set up Container Runtime (containerd)

# Download and unzip the containerd application
curl -LO https://github.com/containerd/containerd/releases/download/v1.7.0/containerd-1.7.0-linux-arm64.tar.gz
sudo tar Czxvf /usr/local containerd-1.7.0-linux-arm64.tar.gz

# Download and place the systemd unit file
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/lib/systemd/system
sudo mv containerd.service /usr/lib/systemd/system/

# Create containerd configuration file
sudo mkdir -p /etc/containerd/
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Enable systemd CGroup driver
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# Configure crictl to work with containerd
sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock

# Set containerd to auto-start at boot (enable it).
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

