#!/bin/bash
# Usage: ./fetch-paper.sh <paper-url> <output-name>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <paper-url> <output-name>"
    exit 1
fi

curl -L "$1" -o "papers/$2.pdf"
