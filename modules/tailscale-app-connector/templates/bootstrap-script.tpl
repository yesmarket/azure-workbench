#!/bin/bash
curl -fsSL https://tailscale.com/install.sh | sh
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf
sudo tailscale up --authkey=${auth_key} --advertise-connector --advertise-tags=${advertised_tags}
#curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
