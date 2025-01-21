#!/bin/bash
set -e

# Initialize git config
git config --global user.email "docker@popl2025.local"
git config --global user.name "POPL Docker"

exec "$@"
