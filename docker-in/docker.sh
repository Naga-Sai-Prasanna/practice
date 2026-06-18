#!/bin/bash

# we are creating 50gb root, but only 20gb is partitioned
# remaining 30gb we need to extend using below commands
sudo growpart /dev/nvme0n1 4
sudo lvextend -r -L+30G /dev/RootVG/varVol
sudo xfs_growfs /var 


sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo  systemctl enable docker

sudo usermod -aG docker ec2-user