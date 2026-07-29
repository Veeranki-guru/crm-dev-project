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
dnf install -y java-21-openjdk java-21-openjdk-devel >>"$LOG_FILE" 2>&1
VALIDATE $? "Java 21 Installation"

echo ""
echo "Finding Java 21 installation..."

# Find Java 21 executable
JAVA21_BIN=$(find /usr/lib/jvm -type f -path "*/bin/java" | grep "java-21" | head -n 1)

if [ -z "$JAVA21_BIN" ]; then
    echo "Java 21 executable not found."
    echo "Check log: $LOG_FILE"
    exit 1
fi

echo "Java 21 found at:"
echo "$JAVA21_BIN"

# Find Java 21 compiler
JAVAC21_BIN=$(dirname "$JAVA21_BIN")/javac

if [ ! -x "$JAVAC21_BIN" ]; then
    echo "Java 21 javac compiler not found."
    echo "Check log: $LOG_FILE"
    exit 1
fi

echo ""
echo "Setting Java 21 as the default..."

# Register Java 21 with alternatives
alternatives --install /usr/bin/java java "$JAVA21_BIN" 2100 >>"$LOG_FILE" 2>&1
alternatives --install /usr/bin/javac javac "$JAVAC21_BIN" 2100 >>"$LOG_FILE" 2>&1

# Set Java 21 as default
alternatives --set java "$JAVA21_BIN" >>"$LOG_FILE" 2>&1
alternatives --set javac "$JAVAC21_BIN" >>"$LOG_FILE" 2>&1

echo ""
echo "Configuring JAVA_HOME..."

# Determine JAVA_HOME
JAVA_HOME_PATH=$(dirname "$(dirname "$JAVA21_BIN")")

# Create system-wide Java environment file
cat > /etc/profile.d/java.sh <<EOF
export JAVA_HOME=$JAVA_HOME_PATH
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

chmod 644 /etc/profile.d/java.sh

# Set JAVA_HOME for current script/session
export JAVA_HOME="$JAVA_HOME_PATH"
export PATH="$JAVA_HOME/bin:$PATH"

echo ""
echo "========================================="
echo "Java Version:"
echo "========================================="

java -version

echo ""
echo "========================================="
echo "Java Compiler Version:"
echo "========================================="

javac -version

echo ""
echo "========================================="
echo "JAVA_HOME:"
echo "========================================="

echo "$JAVA_HOME"

echo ""
echo "========================================="
echo "Validating Java 21..."
echo "========================================="

JAVA_VERSION=$(java -version 2>&1 | head -n 1)

if echo "$JAVA_VERSION" | grep -q '"21'; then
    echo ""
    echo "Java 21 is the active default Java version."
else
    echo ""
    echo "Java 21 validation FAILED."
    echo "Current Java version:"
    java -version
    echo ""
    echo "Java path:"
    readlink -f "$(which java)"
    exit 1
fi

echo ""
echo "Java Path:"
readlink -f "$(which java)"

echo ""
echo "========================================="
echo " Java Installation Completed Successfully"
echo "========================================="
```
