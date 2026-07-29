```bash
#!/bin/bash

set -e

LOG_FILE="/tmp/install-java.log"

VALIDATE() {
    if [ "$1" -eq 0 ]; then
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

# Install Java 21
if dnf install -y java-21-openjdk java-21-openjdk-devel &>>"$LOG_FILE"; then
    echo "Java 21 packages installed successfully."
else
    echo "Java 21 installation failed."
    echo "Check log: $LOG_FILE"
    exit 1
fi

echo ""
echo "Setting Java 21 as the default Java version..."

# Set Java 21 as default
JAVA21_PATH="/usr/lib/jvm/java-21-openjdk"

if [ -x "$JAVA21_PATH/bin/java" ]; then
    alternatives --set java "$JAVA21_PATH/bin/java" &>>"$LOG_FILE" || true
    alternatives --set javac "$JAVA21_PATH/bin/javac" &>>"$LOG_FILE" || true
else
    echo "Java 21 executable not found at $JAVA21_PATH"
    echo "Check log: $LOG_FILE"
    exit 1
fi

echo ""
echo "Java Version:"
java -version

echo ""
echo "Java Compiler Version:"
javac -version

echo ""
echo "JAVA_HOME:"
echo "$JAVA_HOME"

echo ""
echo "Checking Java 21..."

JAVA_VERSION=$(java -version 2>&1 | head -n 1)

if echo "$JAVA_VERSION" | grep -q '"21'; then
    echo "Java 21 is the active default Java version."
else
    echo "WARNING: Java 21 is installed, but it is NOT the active default version."
    echo "Current version:"
    java -version
    exit 1
fi

echo ""
echo "========================================="
echo " Java Installation Completed Successfully"
echo "========================================="
```
