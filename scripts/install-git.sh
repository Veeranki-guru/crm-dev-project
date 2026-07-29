#!/bin/bash

set -e

LOG_FILE="/tmp/install-git.log"

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
echo "       Git Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing Git..."

dnf install -y git &>>"$LOG_FILE"
VALIDATE $? "Git Installation"

echo ""
echo "Git Version:"
git --version

echo ""
echo "========================================="
echo " Git Installation Completed Successfully"
echo "========================================="