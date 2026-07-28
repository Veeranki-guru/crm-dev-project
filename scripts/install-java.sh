#!/bin/bash

set -e

LOG_FILE="/tmp/install-java.log"

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
echo "       Java Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing Java 21..."

dnf install -y java-21-openjdk java-21-openjdk-devel &>>"$LOG_FILE"
VALIDATE $? "Java Installation"

echo ""
echo "Java Version:"
java -version

echo ""
echo "========================================="
echo " Java Installation Completed Successfully"
echo "========================================="