#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

apt update -y
apt upgrade -y

# --- Swap (t3.micro only has 1GB RAM, SonarQube + ES + Postgres need headroom) ---
if [ ! -f /swapfile ]; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

apt install -y openjdk-17-jdk unzip wget curl postgresql postgresql-contrib

# --- Kernel params required by Elasticsearch bootstrap checks ---
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
sysctl -p

# --- Postgres setup ---
sudo -u postgres psql -c "CREATE USER sonar WITH PASSWORD '${sonar_db_password}';"
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"

# --- Download SonarQube (Community Edition, always free) ---
cd /opt
wget -q https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip
unzip -q sonarqube-10.6.0.92116.zip
mv sonarqube-10.6.0.92116 sonarqube

# --- Dedicated non-root user ---
adduser --system --no-create-home --group --disabled-login sonar
chown -R sonar:sonar /opt/sonarqube

# --- Configure DB connection + bind to all interfaces ---
cat >> /opt/sonarqube/conf/sonar.properties <<EOC
sonar.jdbc.username=sonar
sonar.jdbc.password=${sonar_db_password}
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
EOC

# --- PAM limits (covers interactive SSH/su sessions) ---
cat >> /etc/security/limits.conf <<EOC
sonar   -   nofile   65536
sonar   -   nproc    4096
EOC

# --- systemd service — Limit* set explicitly here since systemd ignores
#     /etc/security/limits.conf for services it manages directly ---
cat > /etc/systemd/system/sonarqube.service <<EOC
[Unit]
Description=SonarQube service
After=network.target postgresql.service

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
EOC

systemctl daemon-reload
systemctl enable postgresql
systemctl enable sonarqube
systemctl start sonarqube

# --- Wait for SonarQube's own API to actually be ready (can take a few minutes) ---
echo "Waiting for SonarQube to become available..."
for i in $(seq 1 60); do
  STATUS=$(curl -s -u admin:admin http://localhost:9000/api/system/status | grep -o '"status":"[A-Z]*"' || true)
  if [[ "$STATUS" == '"status":"UP"' ]]; then
    echo "SonarQube is UP"
    break
  fi
  sleep 10
done

# --- Create a custom Quality Gate with conditions on NEW CODE, set as default ---
GATE_NAME="practice-quality-gate"

GATE_ID=$(curl -s -u admin:admin -X POST \
  "http://localhost:9000/api/qualitygates/create" \
  -d "name=${GATE_NAME}" | grep -o '"id":[0-9]*' | grep -o '[0-9]*' || true)

if [ -z "$GATE_ID" ]; then
  GATE_ID=$(curl -s -u admin:admin \
    "http://localhost:9000/api/qualitygates/show?name=${GATE_NAME}" | grep -o '"id":[0-9]*' | grep -o '[0-9]*' || true)
fi

if [ -n "$GATE_ID" ]; then
  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/create_condition" \
    -d "gateId=${GATE_ID}&metric=new_coverage&op=LT&error=80"

  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/create_condition" \
    -d "gateId=${GATE_ID}&metric=new_duplicated_lines_density&op=GT&error=3"

  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/create_condition" \
    -d "gateId=${GATE_ID}&metric=new_maintainability_rating&op=GT&error=1"

  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/create_condition" \
    -d "gateId=${GATE_ID}&metric=new_reliability_rating&op=GT&error=1"

  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/create_condition" \
    -d "gateId=${GATE_ID}&metric=new_security_rating&op=GT&error=1"

  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/create_condition" \
    -d "gateId=${GATE_ID}&metric=new_security_hotspots_reviewed&op=LT&error=100"

  curl -s -u admin:admin -X POST "http://localhost:9000/api/qualitygates/set_as_default" \
    -d "id=${GATE_ID}"

  echo "Quality gate '${GATE_NAME}' created with conditions and set as default."
else
  echo "WARNING: Could not determine gate ID — quality gate setup skipped."
fi

# --- Register a webhook so SonarQube notifies Jenkins when analysis + gate finish ---
# This is what makes waitForQualityGate() in Jenkins actually work — without it,
# Jenkins has no way of knowing the gate result and the pipeline step will hang/timeout.
if [ -n "${jenkins_webhook_url}" ]; then
  curl -s -u admin:admin -X POST "http://localhost:9000/api/webhooks/create" \
    -d "name=Jenkins&url=${jenkins_webhook_url}"
  echo "Webhook registered pointing to ${jenkins_webhook_url}"
fi

echo "=== SonarQube setup complete ==="
