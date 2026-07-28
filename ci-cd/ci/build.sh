#!/bin/bash

set -e

echo "=========================================="
echo "Python Application Build"
echo "=========================================="

cd backend

echo "Python version:"
python3 --version

echo "Creating virtual environment..."

python3 -m venv venv

echo "Activating virtual environment..."

source venv/bin/activate

echo "Upgrading pip..."

pip install --upgrade pip

if [ -f requirements.txt ]; then
    echo "Installing Python dependencies..."
    pip install -r requirements.txt
else
    echo "ERROR: requirements.txt not found."
    exit 1
fi

echo "Python build completed successfully."