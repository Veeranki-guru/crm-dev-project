
#!/bin/bash

set -e

echo "======================================"
echo "CRM DEV CI BUILD"
echo "======================================"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "$PROJECT_ROOT"

echo "Project Root: $PROJECT_ROOT"


# ==================================================
# Validate Backend
# ==================================================

echo "Checking backend..."

test -f backend/app.py || {
    echo "ERROR: backend/app.py not found"
    exit 1
}

test -f backend/requirements.txt || {
    echo "ERROR: backend/requirements.txt not found"
    exit 1
}


# ==================================================
# Validate Frontend
# ==================================================

echo "Checking frontend..."

test -f frontend/index.html || {
    echo "ERROR: frontend/index.html not found"
    exit 1
}

echo "Frontend validation successful."


# ==================================================
# Create Virtual Environment
# ==================================================

echo "Creating Python virtual environment..."

python3 -m venv backend/venv

source backend/venv/bin/activate


# ==================================================
# Install Dependencies
# ==================================================

echo "Upgrading pip..."

python -m pip install --upgrade pip

echo "Installing Python dependencies..."

pip install -r backend/requirements.txt


# ==================================================
# Python Syntax Check
# ==================================================

echo "Checking Python syntax..."

python -m compileall -q backend


# ==================================================
# Application Import Check
# ==================================================

echo "Checking Flask application import..."

cd backend

python -c "import app; print('Flask application import successful')"

cd "$PROJECT_ROOT"


# ==================================================
# Build Completed
# ==================================================

echo "======================================"
echo "CRM DEV BUILD SUCCESSFUL"
echo "======================================"

