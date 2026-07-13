#!/bin/bash
set -e

apt update -y
apt upgrade -y
apt install -y openjdk-17-jdk unzip wget postgresql postgresql-contrib

# Kernel params required by SonarQube's embedded Elasticsearch
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf

# Postgres setup
sudo -u postgres psql -c "CREATE USER sonar WITH PASSWORD '${sonar_db_password}';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"

# Download SonarQube
cd /opt
wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip
unzip -q sonarqube-10.6.0.92116.zip
mv sonarqube-10.6.0.92116 sonarqube

# Dedicated user
adduser --system --no-create-home --group --disabled-login sonar
chown -R sonar:sonar /opt/sonarqube

# Configure DB connection
cat >> /opt/sonarqube/conf/sonar.properties <<EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=${sonar_db_password}
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
EOF

# Raise open file / process limits for the sonar user
cat >> /etc/security/limits.conf <<EOF
sonar   -   nofile   65536
sonar   -   nproc    4096
EOF

# Start SonarQube
sudo -u sonar /opt/sonarqube/bin/linux-x86-64/sonar.sh start
