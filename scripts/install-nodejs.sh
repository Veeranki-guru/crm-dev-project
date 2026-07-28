#!/bin/bash

set -e

LOG_FILE="/tmp/install-nodejs.log"

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
echo "      Node.js Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing required packages..."

dnf install -y curl &>>"$LOG_FILE"
VALIDATE $? "Curl Installation"

echo "Adding NodeSource Repository..."

curl -fsSL https://rpm.nodesource.com/setup_22.x | bash - &>>"$LOG_FILE"
VALIDATE $? "NodeSource Repository"

echo "Installing Node.js..."

dnf install -y nodejs &>>"$LOG_FILE"
VALIDATE $? "Node.js Installation"

echo ""
echo "Node.js Version:"
node -v

echo ""
echo "NPM Version:"
npm -v

echo ""
echo "========================================="
echo " Node.js Installation Completed"
echo "========================================="