#!/bin/bash

set -e

LOG_FILE="/tmp/install-sonarqube.log"

VALIDATE() {
    if [ $1 -eq 0 ]; then
        echo "$2 ... SUCCESS"
    else
        echo "$2 ... FAILURE"
        echo "Check log: $LOG_FILE"
        exit 1
    fi
}

echo "========================================="
echo "     SonarQube Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or sudo."
    exit 1
fi

echo "Installing required packages..."
dnf install -y java-21-openjdk java-21-openjdk-devel wget unzip &>>"$LOG_FILE"
VALIDATE $? "Required Packages Installation"

echo "Creating sonar user..."
id sonar &>/dev/null || useradd sonar
VALIDATE $? "Sonar User Creation"

echo "Downloading SonarQube..."
cd /opt
wget -O sonarqube.zip https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.7.0.110598.zip &>>"$LOG_FILE"
VALIDATE $? "SonarQube Download"

echo "Extracting SonarQube..."
unzip -o sonarqube.zip &>>"$LOG_FILE"
VALIDATE $? "SonarQube Extraction"

SONAR_DIR=$(find /opt -maxdepth 1 -type d -name "sonarqube-*" | head -1)

mv "$SONAR_DIR" /opt/sonarqube

chown -R sonar:sonar /opt/sonarqube

VALIDATE $? "SonarQube Configuration"

echo "Creating systemd service..."

cat >/etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube Service
After=network.target

[Service]
Type=forking
User=sonar
Group=sonar
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

VALIDATE $? "Service File Creation"

echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling SonarQube..."
systemctl enable sonarqube &>>"$LOG_FILE"
VALIDATE $? "Enable SonarQube"

echo "Starting SonarQube..."
systemctl start sonarqube &>>"$LOG_FILE"
VALIDATE $? "Start SonarQube"

echo ""
echo "SonarQube Status:"
systemctl status sonarqube --no-pager

echo ""
echo "========================================="
echo " SonarQube Installation Completed"
echo "========================================="
