#!/bin/bash

set -e

echo "========================================="
echo " Jenkins Installation Started"
echo "========================================="

# Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

# Install required packages
echo "Installing Java 21, fontconfig and curl..."

dnf install -y java-21-openjdk java-21-openjdk-devel fontconfig curl

# Check Java
echo ""
echo "Java Version:"
java -version

# Add Jenkins repository
echo ""
echo "Adding Jenkins repository..."

curl -fsSL \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo \
    -o /etc/yum.repos.d/jenkins.repo

# Import Jenkins GPG key
echo "Importing Jenkins GPG key..."

rpm --import \
    https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
echo ""
echo "Installing Jenkins..."

dnf install -y jenkins

# Enable and start Jenkins
echo ""
echo "Starting Jenkins..."

systemctl enable --now jenkins

# Check Jenkins status
echo ""
echo "Jenkins Status:"

if systemctl is-active --quiet jenkins; then
    echo "Jenkins Service ... RUNNING"
else
    echo "Jenkins Service ... FAILED"
    systemctl status jenkins --no-pager
    exit 1
fi

# Jenkins version
echo ""
echo "Jenkins Version:"

jenkins --version || true

# Final output
echo ""
echo "========================================="
echo " Jenkins Installation Completed"
echo "========================================="

echo ""
echo "Jenkins URL:"
echo "http://YOUR_EC2_PUBLIC_IP:8080"

echo ""
echo "Initial Jenkins Admin Password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

echo ""
echo "Check Jenkins:"
echo "sudo systemctl status jenkins --no-pager"