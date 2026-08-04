#!/bin/bash

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "ERROR: Version is required."
    echo "Usage: ./artifact.sh 1.0.1"
    exit 1
fi

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: Invalid version: $VERSION"
    echo "Expected format: 1.0.1"
    exit 1
fi


PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$PROJECT_ROOT"


ARTIFACT_NAME="crm-dev-${VERSION}.tar.gz"


echo "======================================"
echo "Creating Artifact"
echo "======================================"

echo "Artifact Name:"
echo "$ARTIFACT_NAME"


# Remove old artifact

rm -f "$ARTIFACT_NAME"


# Create new artifact

tar \
    --exclude='.git' \
    --exclude='.git/*' \
    --exclude='.env' \
    --exclude='.env.*' \
    --exclude='backend/venv' \
    --exclude='backend/venv/*' \
    --exclude='frontend/venv' \
    --exclude='frontend/venv/*' \
    --exclude='__pycache__' \
    --exclude='*/__pycache__/*' \
    --exclude='*.pyc' \
    --exclude='*.pyo' \
    --exclude='*.log' \
    --exclude='crm-dev-*.tar.gz' \
    -czf "$ARTIFACT_NAME" \
    backend \
    frontend \
    ci-cd


echo ""
echo "Artifact created successfully."


echo ""
echo "Artifact details:"
ls -lh "$ARTIFACT_NAME"


echo ""
echo "Artifact contents:"
tar -tzf "$ARTIFACT_NAME" | head -50


echo ""
echo "Checking virtual environments..."

if tar -tzf "$ARTIFACT_NAME" | grep -q "venv"; then
    echo "ERROR: venv found inside artifact"
    exit 1
else
    echo "SUCCESS: No venv found inside artifact"
fi


echo ""
echo "======================================"
echo "Artifact Build Completed"
echo "Version: $VERSION"
echo "======================================"