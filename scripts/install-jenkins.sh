```bash
#!/bin/bash

set -e

LOG_FILE="/tmp/install-jenkins.log"

echo "========================================="
echo "      Jenkins Installation Started"
echo "========================================="

# --------------------------------------------------
# Check root privileges
# --------------------------------------------------

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: Please run this script with sudo."
    exit 1
fi

# --------------------------------------------------
# Validation function
# --------------------------------------------------

VALIDATE() {
    if [ "$1" -eq 0 ]; then
        echo "$2 ... SUCCESS"
    else
        echo "$2 ... FAILURE"
        echo "Check log: $LOG_FILE"
        exit 1
    fi
}

# --------------------------------------------------
# Install Java 21
# --------------------------------------------------

echo "Installing Java 21..."

dnf install -y java-21-openjdk java-21-openjdk-devel >>"$LOG_FILE" 2>&1

VALIDATE $? "Java 21 Installation"

echo ""
echo "Checking Java version..."

java -version

# --------------------------------------------------
# Install curl
# --------------------------------------------------

echo ""
echo "Checking curl..."

if command -v curl >/dev/null 2>&1; then
    echo "curl already installed ... SUCCESS"
else
    echo "Installing curl..."

    dnf install -y curl >>"$LOG_FILE" 2>&1

    VALIDATE $? "curl Installation"
fi

# Verify curl
if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is not available."
    exit 1
fi

echo "curl version:"
curl --version | head -n 1

# --------------------------------------------------
# Add Jenkins Repository
# --------------------------------------------------

echo ""
echo "Adding Jenkins Repository..."

curl -fsSL \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo \
    -o /etc/yum.repos.d/jenkins.repo \
    >>"$LOG_FILE" 2>&1

VALIDATE $? "Jenkins Repository"

# --------------------------------------------------
# Import Jenkins GPG Key
# --------------------------------------------------

echo ""
echo "Importing Jenkins GPG Key..."

rpm --import \
    https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key \
    >>"$LOG_FILE" 2>&1

VALIDATE $? "Jenkins GPG Key"

# --------------------------------------------------
# Clean DNF Cache
# --------------------------------------------------

echo ""
echo "Cleaning DNF Cache..."

dnf clean all >>"$LOG_FILE" 2>&1

VALIDATE $? "DNF Cache Cleanup"

# --------------------------------------------------
# Refresh Repository Metadata
# --------------------------------------------------

echo ""
echo "Refreshing DNF Repository Metadata..."

dnf makecache >>"$LOG_FILE" 2>&1

VALIDATE $? "DNF Metadata Refresh"

# --------------------------------------------------
# Install Jenkins
# --------------------------------------------------

echo ""
echo "Installing Jenkins..."

dnf install -y jenkins >>"$LOG_FILE" 2>&1

VALIDATE $? "Jenkins Installation"

# --------------------------------------------------
# Enable Jenkins
# --------------------------------------------------

echo ""
echo "Enabling Jenkins Service..."

systemctl enable jenkins >>"$LOG_FILE" 2>&1

VALIDATE $? "Enable Jenkins"

# --------------------------------------------------
# Start Jenkins
# --------------------------------------------------

echo ""
echo "Starting Jenkins Service..."

systemctl start jenkins >>"$LOG_FILE" 2>&1

VALIDATE $? "Start Jenkins"

# --------------------------------------------------
# Check Jenkins Status
# --------------------------------------------------

echo ""
echo "Checking Jenkins Service..."

if systemctl is-active --quiet jenkins; then
    echo "Jenkins Service ... RUNNING"
else
    echo "Jenkins Service ... FAILED"
    echo ""
    echo "Jenkins Logs:"
    journalctl -u jenkins -n 100 --no-pager
    exit 1
fi

# --------------------------------------------------
# Jenkins Version
# --------------------------------------------------

echo ""
echo "Jenkins Version:"

if command -v jenkins >/dev/null 2>&1; then
    jenkins --version || true
fi

# --------------------------------------------------
# Final Output
# --------------------------------------------------

echo ""
echo "========================================="
echo " Jenkins Installation Completed"
echo "========================================="

echo ""
echo "Jenkins Status:"
systemctl status jenkins --no-pager

echo ""
echo "Jenkins URL:"
echo "http://YOUR_EC2_PUBLIC_IP:8080"

echo ""
echo "Initial Jenkins Admin Password:"
echo "Run:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

echo ""
echo "Installation log:"
echo "$LOG_FILE"
```
