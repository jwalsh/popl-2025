#!/bin/bash

# Usage: ./fetch-papers.sh <doi>
# Fetches paper PDFs and creates annotation templates

DOI="$1"
if [ -z "$DOI" ]; then
    echo "Usage: $0 <doi>"
    exit 1
fi

PAPER_DIR="papers/$(echo $DOI | tr '/' '_')"
mkdir -p "$PAPER_DIR"

# Create annotation template
cat > "$PAPER_DIR/notes.org" << EOF
#+TITLE: Paper Notes: $DOI
#+DATE: $(date +%Y-%m-%d)
#+PROPERTY: header-args :tangle yes :mkdirp t

* Paper Overview
:PROPERTIES:
:DOI: $DOI
:READ_DATE: $(date +%Y-%m-%d)
:END:

* Key Points

* Implementation Notes

* Questions

* Follow-ups
EOF

echo "Created annotation template in $PAPER_DIR"
