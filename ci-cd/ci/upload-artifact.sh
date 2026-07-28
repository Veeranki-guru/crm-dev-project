#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT_NAME"
    exit 1
fi

if [ -z "$NEXUS_URL" ]; then
    echo "ERROR: NEXUS_URL is not set"
    exit 1
fi

if [ -z "$NEXUS_REPOSITORY" ]; then
    echo "ERROR: NEXUS_REPOSITORY is not set"
    exit 1
fi

echo "Uploading:"
echo "$ARTIFACT_NAME"

curl \
    --fail \
    --show-error \
    --user "$NEXUS_USER:$NEXUS_PASSWORD" \
    --upload-file "$ARTIFACT_NAME" \
    "$NEXUS_URL/repository/$NEXUS_REPOSITORY/$ARTIFACT_NAME"

echo "Upload successful."