#!/bin/bash
set -e

PYTHON_VERSION="3.10.18"

echo "Installing Python ${PYTHON_VERSION} via pyenv..."
pyenv install --skip-existing "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"

echo "Python $(pyenv version)"
