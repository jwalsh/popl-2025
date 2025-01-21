#!/bin/bash

echo "Checking POPL 2025 repository setup..."

# Check directory structure
declare -a dirs=(
    "notes" 
    "papers/distinguished" 
    "papers/interesting"
    "papers/followup"
    "docs"
    "slides"
    "bib"
    "lisp"
    "templates"
    ".github/workflows"
)

for dir in "${dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir directory exists"
    else
        echo "✗ Missing $dir directory"
        mkdir -p "$dir"
    fi
done

# Check essential files
declare -a files=(
    "README.org"
    "Makefile"
    "init.el"
    "docker-compose.yml"
    "Dockerfile"
    "_config.yml"
    "bib/popl2025.bib"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ Missing $file"
    fi
done

# Check org files
for day in monday tuesday wednesday thursday friday; do
    if [ -f "notes/${day}.org" ]; then
        echo "✓ ${day}.org exists"
    else
        echo "✗ Missing ${day}.org"
    fi
done

# Test Docker setup
if command -v docker &> /dev/null; then
    echo "Testing Docker build..."
    docker build -t popl2025-test . && echo "✓ Docker build succeeded" || echo "✗ Docker build failed"
fi

# Check GitHub setup
if [ -d ".git" ]; then
    echo "✓ Git repository initialized"
    if git remote -v | grep -q "github.com"; then
        echo "✓ GitHub remote configured"
    else
        echo "✗ GitHub remote not configured"
    fi
else
    echo "✗ Not a git repository"
fi

echo "Setup check complete!"
