#!/bin/bash

set -e

LOG_FILE="/tmp/install-sonar-scanner.log"

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
echo " Sonar Scanner Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing required packages..."

dnf install -y wget unzip java-21-openjdk java-21-openjdk-devel &>>"$LOG_FILE"
VALIDATE $? "Required Packages Installation"

echo "Downloading Sonar Scanner..."

cd /opt

wget -O sonar-scanner.zip \
https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-7.3.0.5189-linux-x64.zip &>>"$LOG_FILE"
VALIDATE $? "Sonar Scanner Download"

echo "Extracting Sonar Scanner..."

unzip -o sonar-scanner.zip &>>"$LOG_FILE"
VALIDATE $? "Sonar Scanner Extraction"

SCANNER_DIR=$(find /opt -maxdepth 1 -type d -name "sonar-scanner-*" | head -1)

mv "$SCANNER_DIR" /opt/sonar-scanner

VALIDATE $? "Move Sonar Scanner"

echo "Creating symbolic link..."

ln -sf /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
VALIDATE $? "Create Symbolic Link"

echo ""
echo "Sonar Scanner Version:"
sonar-scanner --version

echo ""
echo "========================================="
echo " Sonar Scanner Installation Completed"
echo "========================================="