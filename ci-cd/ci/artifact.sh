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

echo "Creating artifact:"
echo "$ARTIFACT_NAME"

rm -f "$ARTIFACT_NAME"

tar \
    --exclude='.git' \
    --exclude='.git/*' \
    --exclude='.env' \
    --exclude='.env.*' \
    --exclude='backend/venv' \
    --exclude='backend/venv/*' \
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

echo "Artifact created successfully."

echo "Artifact details:"
ls -lh "$ARTIFACT_NAME"

echo "Artifact contents:"
tar -tzf "$ARTIFACT_NAME" | head -50