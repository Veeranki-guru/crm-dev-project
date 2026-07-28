#!/bin/bash

set -e

LOG_FILE="/tmp/install-jenkins.log"

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
echo "      Jenkins Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing Java 21..."
dnf install -y java-21-openjdk java-21-openjdk-devel &>>"$LOG_FILE"
VALIDATE $? "Java Installation"

echo "Adding Jenkins Repository..."
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo &>>"$LOG_FILE"
VALIDATE $? "Jenkins Repository"

echo "Importing Jenkins GPG Key..."
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>>"$LOG_FILE"
VALIDATE $? "Jenkins GPG Key"

echo "Installing Jenkins..."
dnf install -y jenkins &>>"$LOG_FILE"
VALIDATE $? "Jenkins Installation"

echo "Enabling Jenkins Service..."
systemctl enable jenkins &>>"$LOG_FILE"
VALIDATE $? "Enable Jenkins"

echo "Starting Jenkins Service..."
systemctl start jenkins &>>"$LOG_FILE"
VALIDATE $? "Start Jenkins"

