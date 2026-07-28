#!/bin/bash
set -e

echo "======================================"
echo "Creating Versioned Artifact"
echo "======================================"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is not set"
    exit 1
fi

ARTIFACT_NAME="crm-dev-${APP_VERSION}.tar.gz"

echo "Version: ${APP_VERSION}"
echo "Artifact: ${ARTIFACT_NAME}"

tar --exclude='.git' \
    --exclude='.env' \
    --exclude='venv' \
    --exclude='__pycache__' \
    -czf "${ARTIFACT_NAME}" \
    backend frontend

ls -lh "${ARTIFACT_NAME}"

echo "Artifact created successfully."