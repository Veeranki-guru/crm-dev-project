#!/bin/bash
set -e

LOG_FILE="/tmp/install-sonar-scanner.log"
: > "$LOG_FILE"   # truncate old log so stale output doesn't confuse debugging

SCANNER_VERSION="8.1.0.6389"   # latest as of 2026-07; bump as needed
DOWNLOAD_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SCANNER_VERSION}-linux-x64.zip"

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
echo " Sonar Scanner Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

echo "Installing required packages..."
dnf install -y curl unzip java-21-openjdk java-21-openjdk-devel >>"$LOG_FILE" 2>&1
VALIDATE $? "Required Packages Installation"

cd /opt

echo "Downloading Sonar Scanner ($SCANNER_VERSION)..."
# -A sets a browser-like User-Agent: binaries.sonarsource.com's WAF returns 403
# for some non-browser UAs (including curl's default), even though the URL is valid.
curl -fL \
  -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36" \
  -o sonar-scanner.zip \
  "$DOWNLOAD_URL" >>"$LOG_FILE" 2>&1
VALIDATE $? "Sonar Scanner Download"

echo "Validating ZIP File..."
unzip -t sonar-scanner.zip >>"$LOG_FILE" 2>&1
VALIDATE $? "ZIP File Validation"

echo "Extracting Sonar Scanner..."
unzip -o sonar-scanner.zip >>"$LOG_FILE" 2>&1
VALIDATE $? "Sonar Scanner Extraction"

SCANNER_DIR=$(find /opt -maxdepth 1 -type d -name "sonar-scanner-*" | head -n 1)
if [ -z "$SCANNER_DIR" ]; then
    echo "Sonar Scanner directory not found."
    exit 1
fi

if [ -d /opt/sonar-scanner ]; then
    rm -rf /opt/sonar-scanner
fi
mv "$SCANNER_DIR" /opt/sonar-scanner
VALIDATE $? "Move Sonar Scanner"

echo "Creating Symbolic Link..."
ln -sf /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
VALIDATE $? "Create Symbolic Link"

echo "Configuring PATH..."
cat >/etc/profile.d/sonar-scanner.sh <<EOF
export PATH=/opt/sonar-scanner/bin:\$PATH
EOF
chmod 644 /etc/profile.d/sonar-scanner.sh
source /etc/profile.d/sonar-scanner.sh

rm -f /opt/sonar-scanner.zip

echo ""
echo "Sonar Scanner Version:"
sonar-scanner --version
VALIDATE $? "Sonar Scanner Verification"

echo ""
echo "========================================="
echo " Sonar Scanner Installation Completed"
echo "========================================="