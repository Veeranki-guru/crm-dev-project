#!/bin/bash
set -e

echo "======================================"
echo "Running QA / Tests"
echo "======================================"

cd backend

source venv/bin/activate

if [ -d "tests" ]; then
    pytest -v
else
    echo "No tests directory found."
    echo "Running Python syntax validation..."

    python -m compileall .

    echo "QA validation completed."
fi