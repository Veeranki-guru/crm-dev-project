#!/bin/bash
set -e

echo "======================================"
echo "Packaging CRM application"
echo "======================================"

VERSION="${APP_VERSION}"

if [ -z "$VERSION" ]; then
    echo "ERROR: APP_VERSION is not set"
    exit 1
fi

ARTIFACT_NAME="crm-dev-${VERSION}.tar.gz"

echo "Application Version: ${VERSION}"
echo "Artifact: ${ARTIFACT_NAME}"

tar --exclude='.git' \
    --exclude='.env' \
    --exclude='venv' \
    --exclude='__pycache__' \
    -czf "${ARTIFACT_NAME}" \
    backend frontend

echo "Artifact created successfully:"
ls -lh "${ARTIFACT_NAME}"