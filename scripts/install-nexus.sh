#!/bin/bash

set -e

LOG_FILE="/tmp/install-nexus.log"

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
echo "      Nexus Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing Java 21..."

dnf install -y java-21-openjdk java-21-openjdk-devel wget tar &>>"$LOG_FILE"
VALIDATE $? "Java Installation"

echo "Creating Nexus User..."

id nexus &>/dev/null || useradd nexus
VALIDATE $? "Nexus User Creation"

echo "Downloading Nexus Repository Manager..."

cd /opt

wget -O nexus.tar.gz \
https://download.sonatype.com/nexus/3/latest-unix.tar.gz &>>"$LOG_FILE"
VALIDATE $? "Nexus Download"

echo "Extracting Nexus..."

tar -xzf nexus.tar.gz &>>"$LOG_FILE"
VALIDATE $? "Nexus Extraction"

NEXUS_DIR=$(find /opt -maxdepth 1 -type d -name "nexus-*" | head -1)

mv "$NEXUS_DIR" /opt/nexus
VALIDATE $? "Move Nexus"

mkdir -p /opt/sonatype-work

chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work

echo "Configuring Nexus..."

sed -i 's/^#run_as_user=""/run_as_user="nexus"/' /opt/nexus/bin/nexus.rc

VALIDATE $? "Nexus Configuration"

echo "Creating systemd service..."

cat >/etc/systemd/system/nexus.service <<EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

VALIDATE $? "Service File"

echo "Reloading systemd..."

systemctl daemon-reload

echo "Enabling Nexus..."

systemctl enable nexus &>>"$LOG_FILE"
VALIDATE $? "Enable Nexus"

echo "Starting Nexus..."

systemctl start nexus &>>"$LOG_FILE"
VALIDATE $? "Start Nexus"

echo ""
echo "Nexus Status:"
systemctl status nexus --no-pager

echo ""
echo "========================================="
echo " Nexus Installation Completed"
echo "========================================="
echo "Access Nexus:"
echo "http://<EC2-Public-IP>:8081"

echo ""
echo "Initial Admin Password:"
cat /opt/sonatype-work/nexus3/admin.password