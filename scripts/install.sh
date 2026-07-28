#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "CRM DevOps Environment Installation"
echo "=========================================="

echo "Installing Java..."
sudo bash "$SCRIPT_DIR/install-java.sh"

echo "Installing Git..."
sudo bash "$SCRIPT_DIR/install-git.sh"

echo "Installing PostgreSQL..."
sudo bash "$SCRIPT_DIR/install-postgresql.sh"

echo "Installing Jenkins..."
sudo bash "$SCRIPT_DIR/install-jenkins.sh"

echo "Installing Nexus..."
sudo bash "$SCRIPT_DIR/install-nexus.sh"

echo "Installing SonarQube..."
sudo bash "$SCRIPT_DIR/install-sonarqube.sh"

echo "Installing Sonar Scanner..."
sudo bash "$SCRIPT_DIR/install-sonar-scanner.sh"

echo "=========================================="
echo "Installation completed successfully."
echo "=========================================="