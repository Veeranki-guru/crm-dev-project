#!/bin/bash

set -e

VERSION="$1"

if [ -z "$VERSION" ]; then

    echo "ERROR: Version is required."

    echo "Usage: ./download-version.sh 1.0.1"

    exit 1

fi


echo "Downloading version: $VERSION"


mkdir -p deployment


curl \
    -u "$NEXUS_USER:$NEXUS_PASSWORD" \
    -o "deployment/crm-dev-${VERSION}.tar.gz" \
    "$NEXUS_URL/repository/crm-dev-releases/crm-dev-${VERSION}.tar.gz"


echo "Download completed."