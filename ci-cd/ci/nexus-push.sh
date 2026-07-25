#!/bin/bash

set -e

echo "Uploading artifact to Nexus..."

VERSION=$(cat VERSION)

PACKAGE="packages/crm-dev-${VERSION}.tar.gz"

if [ ! -f "$PACKAGE" ]; then

    echo "ERROR: Package not found: $PACKAGE"

    exit 1

fi

curl \
    -u "$NEXUS_USER:$NEXUS_PASSWORD" \
    --upload-file "$PACKAGE" \
    "$NEXUS_URL/repository/crm-dev-releases/crm-dev-${VERSION}.tar.gz"

echo "Artifact uploaded successfully."

echo "Version: $VERSION"