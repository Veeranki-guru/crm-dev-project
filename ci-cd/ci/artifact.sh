#!/bin/bash

set -e

VERSION="1.0.${BUILD_NUMBER:-1}"

echo "$VERSION" > VERSION

echo "Application Version: $VERSION"