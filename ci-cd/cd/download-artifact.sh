#!/bin/bash
set -e

echo "======================================"
echo "Downloading Artifact from Nexus"
echo "======================================"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is not set"
    exit 1
fi

ARTIFACT_NAME="crm-dev-${APP_VERSION}.tar.gz"

mkdir -p deployment

curl -f \
    -u "${NEXUS_USER}:${NEXUS_PASSWORD}" \
    -o "deployment/${ARTIFACT_NAME}" \
    "${NEXUS_URL}/repository/${NEXUS_REPOSITORY}/${ARTIFACT_NAME}"

echo "Artifact downloaded successfully."

ls -lh deployment/