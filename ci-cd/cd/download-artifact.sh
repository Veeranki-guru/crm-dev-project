#!/bin/bash

set -e

LOG_FILE="/tmp/download-artifact.log"

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
echo "     Download Artifact from Nexus"
echo "========================================="

# Nexus Configuration
NEXUS_URL="http://localhost:8081"
NEXUS_REPOSITORY="crm-dev"
NEXUS_USERNAME="admin"
NEXUS_PASSWORD="YOUR_NEXUS_PASSWORD"

# Artifact Information
ARTIFACT_NAME="crm-dev.zip"
DOWNLOAD_DIR="/opt/artifacts"

mkdir -p "$DOWNLOAD_DIR"

echo "Downloading Artifact..."

curl -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" \
-o "$DOWNLOAD_DIR/$ARTIFACT_NAME" \
"$NEXUS_URL/repository/$NEXUS_REPOSITORY/$ARTIFACT_NAME" \
&>>"$LOG_FILE"

VALIDATE $? "Artifact Download"

echo ""

if [ -f "$DOWNLOAD_DIR/$ARTIFACT_NAME" ]; then
    echo "Artifact Downloaded Successfully"
    ls -lh "$DOWNLOAD_DIR/$ARTIFACT_NAME"
else
    echo "Artifact Download Failed"
    exit 1
fi

echo ""
echo "========================================="
echo " Download Completed Successfully"
echo "========================================="