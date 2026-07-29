#!/bin/bash

set -e

VERSION="$1"
NEXUS_URL="$2"
NEXUS_REPOSITORY="$3"
NEXUS_USER="$4"
NEXUS_PASSWORD="$5"

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

ARTIFACT_NAME="crm-dev-${VERSION}.tar.gz"

DOWNLOAD_URL="${NEXUS_URL}/repository/${NEXUS_REPOSITORY}/${ARTIFACT_NAME}"

echo "======================================"
echo "Downloading Artifact"
echo "======================================"

echo "Version: $VERSION"
echo "Artifact: $ARTIFACT_NAME"
echo "Repository: $NEXUS_REPOSITORY"

rm -f "$ARTIFACT_NAME"

curl \
    --fail \
    --show-error \
    --location \
    --user "${NEXUS_USER}:${NEXUS_PASSWORD}" \
    --output "$ARTIFACT_NAME" \
    "$DOWNLOAD_URL"

if [ ! -s "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact download failed."
    exit 1
fi

echo "Artifact downloaded successfully."

ls -lh "$ARTIFACT_NAME"