#!/bin/bash
set -e

echo "======================================"
echo "Uploading Artifact to Nexus"
echo "======================================"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is not set"
    exit 1
fi

ARTIFACT_NAME="crm-dev-${APP_VERSION}.tar.gz"

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT_NAME"
    exit 1
fi

echo "Uploading:"
echo "$ARTIFACT_NAME"

curl -f \
    -u "${NEXUS_USER}:${NEXUS_PASSWORD}" \
    --upload-file "${ARTIFACT_NAME}" \
    "${NEXUS_URL}/repository/${NEXUS_REPOSITORY}/${ARTIFACT_NAME}"

echo "Artifact uploaded successfully."