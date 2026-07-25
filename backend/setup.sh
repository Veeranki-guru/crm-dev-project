#!/bin/bash

set -e

echo "======================================"
echo " CRM-DE Python Environment Setup"
echo "======================================"

# Project directory
PROJECT_DIR="$(pwd)"

echo "Project directory: $PROJECT_DIR"


# Check Python
if ! command -v python3 &> /dev/null
then
    echo "ERROR: Python3 is not installed."
    exit 1
fi

echo "Python version:"
python3 --version


# Create virtual environment
if [ ! -d "venv" ]
then
    echo "Creating Python virtual environment..."

    python3 -m venv venv

    echo "Virtual environment created successfully."
else
    echo "Virtual environment already exists."
fi


# Activate virtual environment
echo "Activating virtual environment..."

source venv/bin/activate


# Upgrade pip
echo "Upgrading pip..."

python -m pip install --upgrade pip


# Install dependencies
if [ -f "requirements.txt" ]
then

    echo "Installing Python dependencies..."

    pip install -r requirements.txt

    echo "Dependencies installed successfully."

else

    echo "ERROR: requirements.txt not found."

    exit 1

fi


echo ""
echo "======================================"
echo " Setup Completed Successfully"
echo "======================================"

echo "Python:"
which python

echo "Pip:"
which pip

echo "Installed packages:"
pip list

echo ""
echo "Virtual environment location:"
echo "$PROJECT_DIR/venv"

echo ""
echo "To activate manually:"
echo "source venv/bin/activate"

echo ""
echo "To run Flask:"
echo "python app.py"

echo ""
echo "To run Gunicorn:"
echo "gunicorn --bind 0.0.0.0:8000 app:app"