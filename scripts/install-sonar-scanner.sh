#!/bin/bash

set -e

LOG_FILE="/tmp/install-sonar-scanner.log"

VALIDATE() {
    if [ "$1" -eq 0 ]; then
        echo "$2 ... SUCCESS"
    else
        echo "$2 ... FAILURE"
        echo "Check log: $LOG_FILE"
        exit 1
    fi
}

echo "========================================="
echo " Sonar Scanner Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "Installing required packages..."

dnf install -y curl unzip java-21-openjdk java-21-openjdk-devel >>"$LOG_FILE" 2>&1
VALIDATE $? "Required Packages Installation"

cd /opt

echo "Downloading Sonar Scanner..."

curl -L -o sonar-scanner.zip \
https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-7.3.0.5189-linux-x64.zip >>"$LOG_FILE" 2>&1
VALIDATE $? "Sonar Scanner Download"

echo "Extracting Sonar Scanner..."

unzip -o sonar-scanner.zip >>"$LOG_FILE" 2>&1
VALIDATE $? "Sonar Scanner Extraction"

SCANNER_DIR=$(find /opt -maxdepth 1 -type d -name "sonar-scanner-*" | head -1)

if [ -z "$SCANNER_DIR" ]; then
    echo "Sonar Scanner directory not found."
    exit 1
fi

rm -rf /opt/sonar-scanner

mv "$SCANNER_DIR" /opt/sonar-scanner
VALIDATE $? "Move Sonar Scanner"

if [ ! -f /opt/sonar-scanner/bin/sonar-scanner ]; then
    echo "Sonar Scanner binary not found."
    exit 1
fi

ln -sf /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
VALIDATE $? "Create Symbolic Link"

cat >/etc/profile.d/sonar-scanner.sh <<EOF
export PATH=/opt/sonar-scanner/bin:\$PATH
EOF

chmod 644 /etc/profile.d/sonar-scanner.sh

source /etc/profile.d/sonar-scanner.sh

echo ""
echo "Sonar Scanner Version:"
sonar-scanner --version

echo ""
echo "========================================="
echo " Sonar Scanner Installation Completed"
echo "========================================="