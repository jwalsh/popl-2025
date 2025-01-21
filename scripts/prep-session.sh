#!/bin/bash
# Usage: ./prep-session.sh <session-name>

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <session-name>"
    exit 1
fi

SESSION=$1
DATE=$(date +%Y-%m-%d)

cat > "notes/sessions/${SESSION}.org" << EOF
#+TITLE: POPL 2025 - ${SESSION}
#+DATE: ${DATE}
#+OPTIONS: toc:2 num:nil

* Session Notes
** Overview
** Key Points
** Questions
** Follow-ups
EOF
