#!/bin/bash

set -e

echo "======================================"
echo "CRM-DEV Tests"
echo "======================================"


PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$PROJECT_ROOT/backend"


# Activate virtual environment
source venv/bin/activate


# Install test dependency
pip install pytest


# Run tests
echo "Running Python tests..."

pytest tests/


echo "======================================"
echo "All Tests Passed"
echo "======================================"