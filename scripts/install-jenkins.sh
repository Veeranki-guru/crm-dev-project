```bash
#!/bin/bash

set -e

LOG="/tmp/install-jenkins.log"

echo "========================================="
echo " Jenkins Installation Started"
echo "========================================="

# Root check
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run with sudo"
    exit 1
fi

# Java 21
echo "Installing Java 21..."
dnf install -y java-21-openjdk java-21-openjdk-devel >> "$LOG" 2>&1

echo "Java Version:"
java -version

# Curl
echo "Checking curl..."
if ! command -v curl >/dev/null 2>&1; then
    echo "Installing curl..."
    dnf install -y curl >> "$LOG" 2>&1
fi

echo "curl: $(curl --version | head -n 1)"

# Jenkins Repository
echo "Adding Jenkins repository..."

curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo \
    -o /etc/yum.repos.d/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
echo "Installing Jenkins..."

dnf clean all >> "$LOG" 2>&1
dnf makecache >> "$LOG" 2>&1
dnf install -y jenkins >> "$LOG" 2>&1

# Enable and start
echo "Starting Jenkins..."

systemctl enable --now jenkins

# Check status
echo ""
echo "Jenkins Status:"
systemctl is-active jenkins

echo ""
echo "Jenkins Version:"
jenkins --version || true

echo ""
echo "========================================="
echo " Jenkins Installation Completed"
echo "========================================="

echo ""
echo "Jenkins URL:"
echo "http://100.26.32.109:8080"

echo ""
echo "Initial Admin Password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```
