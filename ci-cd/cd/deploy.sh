#!/bin/bash
set -e

echo "======================================"
echo "Deploying CRM Application"
echo "======================================"

if [ -z "$APP_VERSION" ]; then
    echo "ERROR: APP_VERSION is not set"
    exit 1
fi

ARTIFACT_NAME="crm-dev-${APP_VERSION}.tar.gz"

DEPLOY_PATH="/opt/crm-dev"

echo "Version: ${APP_VERSION}"
echo "Artifact: ${ARTIFACT_NAME}"

sudo mkdir -p "$DEPLOY_PATH"

sudo tar -xzf \
    "deployment/${ARTIFACT_NAME}" \
    -C "$DEPLOY_PATH" \
    --strip-components=1

echo "Restarting CRM application..."

sudo systemctl restart crm-dev

echo "Checking application status..."

sudo systemctl status crm-dev --no-pager

echo "Deployment completed successfully."