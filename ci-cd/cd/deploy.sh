#!/bin/bash

set -e

APP_VERSION="$1"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is required"
    echo "Usage: $0 <version>"
    exit 1
fi

PROJECT_NAME="crm-dev"
ARTIFACT_NAME="${PROJECT_NAME}-${APP_VERSION}.tar.gz"

DEPLOY_PATH="/opt/crm-dev"

echo "======================================"
echo "CRM Deployment"
echo "======================================"
echo "Version: $APP_VERSION"
echo "Artifact: $ARTIFACT_NAME"

# Check artifact
if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT_NAME"
    exit 1
fi

# Create deployment directory
sudo mkdir -p "$DEPLOY_PATH"

# Remove previous application files
sudo rm -rf "$DEPLOY_PATH/backend"
sudo rm -rf "$DEPLOY_PATH/frontend"
sudo rm -rf "$DEPLOY_PATH/scripts"

# Extract new version
sudo tar -xzf "$ARTIFACT_NAME" -C "$DEPLOY_PATH"

# Restart application
sudo systemctl restart crm-dev

# Check application
if sudo systemctl is-active --quiet crm-dev; then
    echo "CRM application started successfully."
else
    echo "ERROR: CRM application failed to start."
    sudo systemctl status crm-dev --no-pager
    exit 1
fi

echo "======================================"
echo "Deployment successful"
echo "Version: $APP_VERSION"
echo "======================================"