#!/bin/bash

apt update -y

apt install -y unzip wget curl zip

apt install -y openjdk-17-jdk

apt install -y postgresql postgresql-contrib

systemctl enable postgresql
systemctl start postgresql

sudo -u postgres psql <<EOF
CREATE USER sonar WITH PASSWORD 'sonar';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
EOF

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.6.0.109173.zip

unzip sonarqube-25.6.0.109173.zip

mv sonarqube-* /opt/sonarqube

useradd sonar

chown -R sonar:sonar /opt/sonarqube

cat <<EOF >/opt/sonarqube/conf/sonar.properties

sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube

EOF

cat <<EOF >/etc/systemd/system/sonarqube.service

[Unit]
Description=SonarQube

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target

EOF

sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf

systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube