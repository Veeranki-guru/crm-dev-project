#!/bin/bash

set -e

LOG_FILE="/tmp/upload-artifact.log"

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
echo "      Upload Artifact to Nexus"
echo "========================================="

# Nexus Configuration
NEXUS_URL="http://localhost:8081"
NEXUS_REPOSITORY="crm-dev"
NEXUS_USERNAME="admin"
NEXUS_PASSWORD="YOUR_NEXUS_PASSWORD"

ARTIFACT_NAME="crm-dev.zip"
ARTIFACT_PATH="./$ARTIFACT_NAME"

# Check artifact exists
if [ ! -f "$ARTIFACT_PATH" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT_NAME"
    exit 1
fi

echo "Uploading artifact to Nexus..."

curl -v -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" \
--upload-file "$ARTIFACT_PATH" \
"$NEXUS_URL/repository/$NEXUS_REPOSITORY/$ARTIFACT_NAME" \
&>>"$LOG_FILE"

VALIDATE $? "Artifact Upload"

echo ""
echo "========================================="
echo " Artifact Uploaded Successfully"
echo "========================================="

