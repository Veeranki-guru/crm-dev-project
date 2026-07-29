
#!/bin/bash

set -e

LOG="/tmp/install-jenkins.log"

echo "========================================="
echo " Jenkins Installation Started"
echo "========================================="

# Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Run this script with sudo"
    exit 1
fi

# Install required packages
echo "Installing Java 21, Curl and Fontconfig..."

dnf install -y java-21-openjdk java-21-openjdk-devel curl fontconfig \
    >> "$LOG" 2>&1

echo "Required packages installed successfully."

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

dnf install -y jenkins >> "$LOG" 2>&1

# Enable and start Jenkins
echo ""
echo "Starting Jenkins..."

systemctl enable --now jenkins

# Check Jenkins status
echo ""
echo "Checking Jenkins status..."

if systemctl is-active --quiet jenkins; then
    echo "Jenkins Service ... RUNNING"
else
    echo "Jenkins Service ... FAILED"
    systemctl status jenkins --no-pager
    exit 1
fi

# Final output
echo ""
echo "========================================="
echo " Jenkins Installation Completed"
echo "========================================="

echo ""
echo "Java Version:"
java -version

echo ""
echo "Jenkins Version:"
jenkins --version || true

echo ""
echo "Jenkins Status:"
systemctl status jenkins --no-pager

echo ""
echo "Initial Jenkins Admin Password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

echo ""
echo "Installation Log:"
echo "$LOG"

