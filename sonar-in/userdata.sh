#!/bin/bash

apt update -y

apt install -y docker.io docker-compose-plugin

systemctl enable docker
systemctl start docker

sysctl -w vm.max_map_count=524288
echo "vm.max_map_count=524288" >> /etc/sysctl.conf

docker volume create sonarqube_data
docker volume create sonarqube_extensions
docker volume create sonarqube_logs

docker run -d \
--name sonarqube \
-p 9000:9000 \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_extensions:/opt/sonarqube/extensions \
-v sonarqube_logs:/opt/sonarqube/logs \
-e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
sonarqube:community