#!/bin/bash

set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "========================================="
echo "Installing Java 21..."
echo "========================================="

dnf install -y java-21-openjdk java-21-openjdk-devel

echo ""
echo "Java Installed Successfully"

echo ""
java -version
javac -version

JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$(which java)")")")

echo ""
echo "JAVA_HOME=$JAVA_HOME"

cat >/etc/profile.d/java.sh <<EOF
export JAVA_HOME=$JAVA_HOME
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

chmod 644 /etc/profile.d/java.sh

echo ""
echo "========================================="
echo "Java installation completed successfully."
echo "========================================="