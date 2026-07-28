#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

echo "Creating artifact: ${ARTIFACT_NAME}"

rm -rf package
mkdir -p package

cp -r backend package/
cp -r frontend package/
cp -r scripts package/

tar -czf "${ARTIFACT_NAME}" -C package .

echo "Artifact created successfully:"
ls -lh "${ARTIFACT_NAME}"