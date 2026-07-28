#!/bin/bash
set -e

echo "======================================"
echo "CRM Application Health Check"
echo "======================================"

APP_URL="http://localhost:5000/health"

echo "Checking: ${APP_URL}"

sleep 10

curl --fail "$APP_URL"

echo ""
echo "Health check successful."