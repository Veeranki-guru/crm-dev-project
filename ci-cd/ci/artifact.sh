#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    echo "Usage: $0 <version>"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

echo "Creating artifact: $ARTIFACT_NAME"

rm -f "$ARTIFACT_NAME"

tar \
    --exclude="backend/venv" \
    --exclude=".git" \
    --exclude=".env" \
    -czf "$ARTIFACT_NAME" \
    backend frontend scripts

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact creation failed"
    exit 1
fi

echo "Artifact created successfully:"
ls -lh "$ARTIFACT_NAME"