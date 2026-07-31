#!/bin/bash

set -e

echo "=========================================="
echo "Running Python QA Tests"
echo "=========================================="

cd ../../backend

if [ ! -d "venv" ]; then
    echo "ERROR: Python virtual environment not found."
    echo "Run build.sh first."
    exit 1
fi

source venv/bin/activate

if [ -d "tests" ]; then

    echo "Installing pytest..."

    pip install pytest

    echo "Running pytest..."

    pytest -v

else

    echo "WARNING: tests directory not found."
    echo "No automated tests available."

fi

echo "QA stage completed."