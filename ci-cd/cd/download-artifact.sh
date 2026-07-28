#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

echo "Downloading:"
echo "$ARTIFACT_NAME"

curl \
    --fail \
    --show-error \
    --user "$NEXUS_USER:$NEXUS_PASSWORD" \
    --output "$ARTIFACT_NAME" \
    "$NEXUS_URL/repository/$NEXUS_REPOSITORY/$ARTIFACT_NAME"

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Download failed"
    exit 1
fi

echo "Download successful."

ls -lh "$ARTIFACT_NAME"