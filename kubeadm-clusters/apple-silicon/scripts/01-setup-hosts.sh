# Set hostfile entries
cat /tmp/hostentries | sudo tee -a /etc/hosts

# Export internal IP of primary NIC as an environment variable
echo "INTERNAL_IP=$(ip route | grep default | awk '{ print $9 }')" | sudo tee -a /etc/environment > /dev/null

# Enable password auth in sshd so we can use ssh-copy-id
sudo sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sudo sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Set password for ubuntu user (it's something random by default)
echo 'ubuntu:ubuntu' | sudo chpasswd