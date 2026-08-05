#!/bin/bash

set -e

########################################
# CRM Deployment Script
########################################

APP_NAME="crm-dev"

VERSION="$1"
DEPLOY_PATH="$2"

if [ -z "$VERSION" ]; then
    echo "ERROR: Version is required."
    exit 1
fi

if [ -z "$DEPLOY_PATH" ]; then
    DEPLOY_PATH="/var/www/crm-dev-project"
fi

ARTIFACT_NAME="${APP_NAME}-${VERSION}.tar.gz"

BACKUP_DIR="/opt/crm-dev-backups"

echo "======================================"
echo " Starting Deployment"
echo "======================================"

echo "Version     : $VERSION"
echo "Deploy Path : $DEPLOY_PATH"
echo "Artifact    : $ARTIFACT_NAME"

########################################
# Check Artifact
########################################

if [ ! -f "$ARTIFACT_NAME" ]; then
    echo "ERROR: Artifact not found: $ARTIFACT_NAME"
    exit 1
fi


########################################
# Create Deployment Directory
########################################

sudo mkdir -p "$DEPLOY_PATH"


########################################
# Backup Current Deployment
########################################

if [ -d "$DEPLOY_PATH/backend" ] || [ -d "$DEPLOY_PATH/frontend" ]; then

    echo "Creating backup..."

    sudo mkdir -p "$BACKUP_DIR"

    TIMESTAMP=$(date +%Y%m%d%H%M%S)

    sudo tar \
        --exclude='backend/venv' \
        -czf "${BACKUP_DIR}/${APP_NAME}-${TIMESTAMP}.tar.gz" \
        -C "$DEPLOY_PATH" \
        backend frontend ci-cd 2>/dev/null || true

    echo "Backup created:"
    echo "${BACKUP_DIR}/${APP_NAME}-${TIMESTAMP}.tar.gz"

fi


########################################
# Extract New Artifact
########################################

echo "Extracting artifact..."

sudo tar \
    -xzf "$ARTIFACT_NAME" \
    -C "$DEPLOY_PATH"


########################################
# Setup Python Virtual Environment
########################################

if [ -f "$DEPLOY_PATH/backend/requirements.txt" ]; then

    echo "Installing Python dependencies..."

    if [ ! -d "$DEPLOY_PATH/backend/venv" ]; then
        sudo python3 -m venv "$DEPLOY_PATH/backend/venv"
    fi


    sudo "$DEPLOY_PATH/backend/venv/bin/pip" install --upgrade pip


    sudo "$DEPLOY_PATH/backend/venv/bin/pip" install \
        -r "$DEPLOY_PATH/backend/requirements.txt"


    echo "Python packages installed."

fi


########################################
# Permissions
########################################

echo "Updating permissions..."

sudo chown -R ec2-user:ec2-user "$DEPLOY_PATH"


########################################
# Restart Application
########################################

echo "Restarting CRM service..."

sudo systemctl daemon-reload

sudo systemctl restart crm-dev


########################################
# Health Check
########################################

echo "Checking service status..."

if sudo systemctl is-active --quiet crm-dev
then
    echo "CRM service is running successfully."
else
    echo "ERROR: CRM service failed."

    sudo systemctl status crm-dev --no-pager

    exit 1
fi


echo "======================================"
echo " Deployment Completed Successfully"
echo " Version: $VERSION"
echo "======================================"