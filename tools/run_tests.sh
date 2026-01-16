#!/bin/bash
# Run pytest with automatic environment setup
# Usage: ./tools/run_tests.sh [pytest args...]
#
# Examples:
#   ./tools/run_tests.sh                                    # Run all tests
#   ./tools/run_tests.sh my-programs/chat-terminal/ -v      # Run specific tests
#   ./tools/run_tests.sh -k "test_port"                     # Run matching tests

set -e
cd "$(dirname "$0")/.."

# Find a Python with pytest installed
find_pytest() {
    # Try common Python versions (prefer newer, but 3.11 often has pytest)
    for py in python3.11 python3.12 python3.13 python3.14 python3; do
        if command -v "$py" &>/dev/null; then
            if "$py" -c "import pytest" 2>/dev/null; then
                echo "$py"
                return 0
            fi
        fi
    done
    return 1
}

PYTHON=$(find_pytest) || {
    echo "pytest not found in any Python installation."
    echo "Installing pytest via pip3..."
    pip3 install --user pytest
    PYTHON=python3
}

echo "Using: $PYTHON ($(command -v "$PYTHON"))"
exec "$PYTHON" -m pytest "$@"
