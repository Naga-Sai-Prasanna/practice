#!/bin/bash

component=$1
environment=$2

dnf install ansible -y 

cd /home/ec2-user
git clone https://github.com/Naga-Sai-Prasanna/ansible-roboshop-roles-tf.git

cd ansible-roboshop-roles-tf
git pull
ansible-playbook -e component=$component environment=$environment roboshop.yaml