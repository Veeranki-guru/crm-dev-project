#!/bin/bash

set -e

echo "======================================"
echo "CRM-DEV Build"
echo "======================================"


PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_ROOT"


# Activate backend virtual environment
source backend/venv/bin/activate


# Install dependencies
echo "Installing Python dependencies..."

pip install -r backend/requirements.txt


# Create build directory
rm -rf build

mkdir -p build


# Copy backend files
echo "Copying backend files..."

cp -r backend/app.py build/
cp -r backend/config.py build/
cp -r backend/database.py build/
cp -r backend/models.py build/
cp -r backend/routes build/
cp -r backend/schemas build/
cp -r backend/utils build/
cp -r backend/requirements.txt build/


# Copy frontend
echo "Copying frontend files..."

cp -r frontend build/frontend


echo "======================================"
echo "Build Completed Successfully"
echo "======================================"

echo "Build directory:"
echo "$PROJECT_ROOT/build"