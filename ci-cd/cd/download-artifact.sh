#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required."
    echo "Usage: $0 <version>"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

echo "Downloading artifact:"
echo "$ARTIFACT_NAME"

curl \
    --fail \
    --show-error \
    --user "$NEXUS_USER:$NEXUS_PASSWORD" \
    -o "$ARTIFACT_NAME" \
    "$NEXUS_URL/repository/$NEXUS_REPOSITORY/$ARTIFACT_NAME"

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact download failed."
    exit 1
fi

echo "Artifact downloaded successfully."