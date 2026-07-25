#!/bin/bash

set -e

echo "======================================"
echo "CRM-DEV Deployment"
echo "======================================"


PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_ROOT"


# Deployment configuration
SERVER_USER="ec2-user"
SERVER_HOST="YOUR_SERVER_IP"
DEPLOY_PATH="/opt/crm-dev"


# Find latest package
PACKAGE=$(ls -t packages/*.tar.gz | head -n 1)


if [ -z "$PACKAGE" ]
then

    echo "ERROR: Deployment package not found."

    exit 1

fi


echo "Deploying package:"
echo "$PACKAGE"


# Copy package to server
scp "$PACKAGE" \
    "$SERVER_USER@$SERVER_HOST:/tmp/"


# Get package filename
PACKAGE_NAME=$(basename "$PACKAGE")


# Deploy on server
ssh "$SERVER_USER@$SERVER_HOST" << EOF

set -e

sudo mkdir -p $DEPLOY_PATH

sudo tar -xzf \
    /tmp/$PACKAGE_NAME \
    -C $DEPLOY_PATH \
    --strip-components=1

sudo systemctl restart crm-dev

sudo systemctl status crm-dev --no-pager

EOF


echo "======================================"
echo "Deployment Completed"
echo "======================================"