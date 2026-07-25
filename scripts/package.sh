#!/bin/bash

set -e

echo "======================================"
echo "CRM-DEV Packaging"
echo "======================================"


PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_ROOT"


# Check build directory
if [ ! -d "build" ]
then

    echo "ERROR: build directory not found."

    echo "Run build.sh first."

    exit 1

fi


# Create packages directory
mkdir -p packages


# Package name
PACKAGE_NAME="crm-dev-$(date +%Y%m%d-%H%M%S).tar.gz"


# Create package
tar -czf \
    "packages/$PACKAGE_NAME" \
    build/


echo "======================================"
echo "Package Created"
echo "======================================"

echo "Package:"
echo "packages/$PACKAGE_NAME"