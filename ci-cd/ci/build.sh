#!/bin/bash

set -e

echo "======================================"
echo "Starting CRM DEV Build"
echo "======================================"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$PROJECT_ROOT"

echo "Project Root: $PROJECT_ROOT"

# --------------------------------------
# Backend Build
# --------------------------------------

echo "Checking Python backend..."

if [ ! -f backend/app.py ]; then
    echo "ERROR: backend/app.py not found."
    exit 1
fi

if [ -f backend/requirements.txt ]; then

    echo "Creating Python virtual environment..."

    python3 -m venv backend/venv

    source backend/venv/bin/activate

    python -m pip install --upgrade pip

    pip install -r backend/requirements.txt

    echo "Python dependencies installed successfully."

    deactivate

else
    echo "WARNING: backend/requirements.txt not found."
    echo "Skipping Python dependency installation."
fi

# --------------------------------------
# Frontend Validation
# --------------------------------------

echo "Checking frontend..."

if [ ! -f frontend/index.html ]; then
    echo "ERROR: frontend/index.html not found."
    exit 1
fi

if [ ! -f frontend/login.html ]; then
    echo "WARNING: frontend/login.html not found."
fi

echo "Frontend validation successful."

# --------------------------------------
# Build Complete
# --------------------------------------

echo "======================================"
echo "Build completed successfully."
echo "======================================"