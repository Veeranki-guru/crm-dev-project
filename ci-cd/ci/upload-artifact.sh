#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

echo "Uploading ${ARTIFACT_NAME} to Nexus..."

curl -f \
    -u "${NEXUS_USER}:${NEXUS_PASSWORD}" \
    --upload-file "${ARTIFACT_NAME}" \
    "${NEXUS_URL}/repository/${NEXUS_REPOSITORY}/${ARTIFACT_NAME}"

echo "Upload successful."

echo "Application : ${PROJECT_NAME}"
echo "Version     : ${APP_VERSION}"
echo "Artifact    : ${ARTIFACT_NAME}"