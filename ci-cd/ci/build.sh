#!/bin/bash
set -e

echo "======================================"
echo "Building Python Flask application"
echo "======================================"

cd backend

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

echo "Python dependencies installed successfully."

python -m py_compile $(find . -name "*.py")

echo "Python build/validation successful."