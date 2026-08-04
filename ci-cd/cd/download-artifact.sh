#!/bin/bash

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
    echo "ERROR: Version is required."
    exit 1
fi

if [ -z "$NEXUS_URL" ]; then
    echo "ERROR: NEXUS_URL is required."
    exit 1
fi

if [ -z "$NEXUS_REPOSITORY" ]; then
    echo "ERROR: NEXUS_REPOSITORY is required."
    exit 1
fi

if [ -z "$NEXUS_USER" ] || [ -z "$NEXUS_PASSWORD" ]; then
    echo "ERROR: Nexus credentials are required."
    exit 1
fi


PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${VERSION}.tar.gz"

DOWNLOAD_URL="${NEXUS_URL}/repository/${NEXUS_REPOSITORY}/${ARTIFACT_NAME}"

echo "======================================"
echo "Downloading Artifact"
echo "======================================"

echo "Version      : ${VERSION}"
echo "Artifact     : ${ARTIFACT_NAME}"
echo "Repository   : ${NEXUS_REPOSITORY}"
echo "Download URL : ${DOWNLOAD_URL}"


rm -f "${ARTIFACT_NAME}"


curl \
--fail \
--show-error \
--location \
--user "${NEXUS_USER}:${NEXUS_PASSWORD}" \
--output "${ARTIFACT_NAME}" \
"${DOWNLOAD_URL}"


if [ ! -s "${ARTIFACT_NAME}" ]; then
    echo "ERROR: Artifact download failed."
    exit 1
fi


echo "======================================"
echo "Artifact downloaded successfully"
echo "======================================"

ls -lh "${ARTIFACT_NAME}"