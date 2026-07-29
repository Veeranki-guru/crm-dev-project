#!/bin/bash

set -e

LOG_FILE="/tmp/install-jenkins.log"

echo "========================================="
echo "      Jenkins Installation Started"
echo "========================================="

# Check root privileges

if [ "$(id -u)" -ne 0 ]; then
echo "ERROR: Please run this script with sudo."
exit 1
fi

# Validation function

VALIDATE() {
if [ "$1" -eq 0 ]; then
echo "$2 ... SUCCESS"
else
echo "$2 ... FAILURE"
echo "Check log: $LOG_FILE"
exit 1
fi
}

# Install Java 21

echo "Installing Java 21..."

dnf install -y java-21-openjdk java-21-openjdk-devel &>>"$LOG_FILE"

VALIDATE $? "Java Installation"

# Check Java

echo "Checking Java version..."
java -version

# Install curl if missing

echo "Checking curl..."

if ! command -v curl >/dev/null 2>&1; then

```
echo "Installing curl..."

dnf install -y curl &>>"$LOG_FILE"

VALIDATE $? "curl Installation"
```

else

```
echo "curl already installed ... SUCCESS"
```

fi

# Add Jenkins Repository

echo "Adding Jenkins Repository..."

curl -L https://pkg.jenkins.io/redhat-stable/jenkins.repo 
-o /etc/yum.repos.d/jenkins.repo 
&>>"$LOG_FILE"

VALIDATE $? "Jenkins Repository"

# Import Jenkins GPG Key

echo "Importing Jenkins GPG Key..."

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key 
&>>"$LOG_FILE"

VALIDATE $? "Jenkins GPG Key"

# Clean DNF cache

echo "Cleaning DNF Cache..."

dnf clean all &>>"$LOG_FILE"

# Refresh repository metadata

echo "Refreshing DNF Repository Metadata..."

dnf makecache &>>"$LOG_FILE"

VALIDATE $? "DNF Metadata Refresh"

# Install Jenkins

echo "Installing Jenkins..."

dnf install -y jenkins &>>"$LOG_FILE"

VALIDATE $? "Jenkins Installation"

# Enable Jenkins

echo "Enabling Jenkins Service..."

systemctl enable jenkins &>>"$LOG_FILE"

VALIDATE $? "Enable Jenkins"

# Start Jenkins

echo "Starting Jenkins Service..."

systemctl start jenkins &>>"$LOG_FILE"

VALIDATE $? "Start Jenkins"

# Check Jenkins

echo "Checking Jenkins Service..."

if systemctl is-active --quiet jenkins; then
echo "Jenkins Service ... RUNNING"
else
echo "Jenkins Service ... FAILED"
echo "Run:"
echo "sudo journalctl -u jenkins -n 100 --no-pager"
exit 1
fi

echo ""
echo "========================================="
echo " Jenkins Installation Completed"
echo "========================================="

echo ""
echo "Jenkins Status:"
systemctl status jenkins --no-pager

echo ""
echo "Initial Jenkins Admin Password:"
echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

echo ""
echo "Installation log:"
echo "$LOG_FILE"
