#!/bin/bash

set -e

echo "======================================"
echo "CRM-DEV Setup"
echo "======================================"

# Move to project root
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_ROOT/backend"

echo "Project directory:"
pwd


# Check Python
if ! command -v python3 >/dev/null 2>&1
then
    echo "ERROR: Python3 is not installed."
    exit 1
fi


echo "Python version:"
python3 --version


# Create virtual environment
if [ ! -d "venv" ]
then

    echo "Creating virtual environment..."

    python3 -m venv venv

else

    echo "Virtual environment already exists."

fi


# Activate virtual environment
source venv/bin/activate


# Upgrade pip
echo "Upgrading pip..."

python -m pip install --upgrade pip


# Install dependencies
if [ -f "requirements.txt" ]
then

    echo "Installing dependencies..."

    pip install -r requirements.txt

else

    echo "ERROR: requirements.txt not found."

    exit 1

fi


echo "======================================"
echo "CRM-DEV Setup Completed"
echo "======================================"