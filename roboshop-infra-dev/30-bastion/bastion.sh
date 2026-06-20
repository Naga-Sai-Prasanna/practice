#!/bin/bash

# we are creating 50gb root, but only 20gb is partitioned
# remaining 30gb we need to extend using below commands
growpart /dev/nvme0n1 4
lvextend -r -L+30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform

# creating databases
cd /home/ec2-user
git clone https://github.com/Naga-Sai-Prasanna/practice.git
chown ec2-user:ec2-user -R roboshop-infra-dev
cd roboshop-infra-dev/40-databases
terraform init
terraform apply -auto-approve

# creating components
cd /home/ec2-user
git clone https://github.com/Naga-Sai-Prasanna/practice.git
chown ec2-user:ec2-user -R roboshop-infra-dev
cd roboshop-infra-dev/90-components
terraform init
terraform apply -auto-approve