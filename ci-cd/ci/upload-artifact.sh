#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    exit 1
fi

PROJECT_NAME="crm-dev"

# Full path to the artifact
ARTIFACT_PATH="/home/ec2-user/crm-dev-project/${PROJECT_NAME}-${APP_VERSION}.tar.gz"

if [ ! -f "$ARTIFACT_PATH" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT_PATH"
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

if [ -z "$NEXUS_USER" ]; then
    echo "ERROR: NEXUS_USER is not set"
    exit 1
fi

if [ -z "$NEXUS_PASSWORD" ]; then
    echo "ERROR: NEXUS_PASSWORD is not set"
    exit 1
fi

echo "Uploading artifact..."
echo "File: $ARTIFACT_PATH"

curl --fail --show-error \
  --user "$NEXUS_USER:$NEXUS_PASSWORD" \
  --upload-file "$ARTIFACT_PATH" \
  "$NEXUS_URL/repository/$NEXUS_REPOSITORY/${PROJECT_NAME}-${APP_VERSION}.tar.gz"

echo "Upload successful."