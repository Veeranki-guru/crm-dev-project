#!/bin/bash

set -e

VERSION="$1"
DEPLOY_PATH="$2"

if [ -z "$VERSION" ]; then
    echo "ERROR: Version is required."
    exit 1
fi

if [ -z "$DEPLOY_PATH" ]; then
    DEPLOY_PATH="//var/www/crm-dev"
fi

ARTIFACT_NAME="crm-dev-${VERSION}.tar.gz"

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact not found:"
    echo "$ARTIFACT_NAME"
    exit 1
fi

echo "======================================"
echo "Starting Deployment"
echo "======================================"

echo "Version: $VERSION"
echo "Deploy Path: $DEPLOY_PATH"

# --------------------------------------
# Create deployment directory
# --------------------------------------

sudo mkdir -p "$DEPLOY_PATH"

# --------------------------------------
# Backup current deployment
# --------------------------------------

if [ -d "$DEPLOY_PATH/backend" ] || [ -d "$DEPLOY_PATH/frontend" ]; then

    BACKUP_DIR="/opt/crm-dev-backups"

    sudo mkdir -p "$BACKUP_DIR"

    TIMESTAMP=$(date +%Y%m%d%H%M%S)

    echo "Creating backup..."

    sudo tar \
        --exclude='backend/venv' \
        -czf "${BACKUP_DIR}/crm-dev-${TIMESTAMP}.tar.gz" \
        -C "$DEPLOY_PATH" \
        backend frontend ci-cd 2>/dev/null || true

fi

# --------------------------------------
# Extract New Version
# --------------------------------------

echo "Extracting artifact..."

sudo tar \
    -xzf "$ARTIFACT_NAME" \
    -C "$DEPLOY_PATH"

# --------------------------------------
# Python Virtual Environment
# --------------------------------------

if [ -f "$DEPLOY_PATH/backend/requirements.txt" ]; then

    echo "Setting up Python virtual environment..."

    if [ ! -d "$DEPLOY_PATH/backend/venv" ]; then
        sudo python3 -m venv "$DEPLOY_PATH/backend/venv"
    fi

    sudo "$DEPLOY_PATH/backend/venv/bin/pip" install \
        --upgrade pip

    sudo "$DEPLOY_PATH/backend/venv/bin/pip" install \
        -r "$DEPLOY_PATH/backend/requirements.txt"

    echo "Python dependencies installed successfully."

fi

# --------------------------------------
# Permissions
# --------------------------------------

echo "Updating ownership..."

sudo chown -R ec2-user:ec2-user "$DEPLOY_PATH"

# --------------------------------------
# Restart Application
# --------------------------------------

echo "Restarting crm-dev service..."

sudo systemctl daemon-reload

sudo systemctl restart crm-dev

# --------------------------------------
# Check Service
# --------------------------------------

if sudo systemctl is-active --quiet crm-dev; then
    echo "crm-dev service is running."
else
    echo "ERROR: crm-dev service failed to start."

    sudo systemctl status crm-dev --no-pager || true

    exit 1
fi

echo "======================================"
echo "Deployment completed successfully."
echo "Version: $VERSION"
echo "======================================"