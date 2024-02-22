cat /tmp/hostentries | sudo tee -a /etc/hosts
ADDRESS="$(ip -4 addr show enp0s1 | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
# Export internal IP as an environment variable
echo "INTERNAL_IP=${ADDRESS}" | sudo tee -a /etc/environment > /dev/null
