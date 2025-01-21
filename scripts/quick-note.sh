#!/bin/bash

# Usage: ./quick-note.sh "session" "Summary of the talk"
SESSION="$1"
NOTES="$2"

if [ -z "$SESSION" ]; then
    echo "Usage: $0 <session> [notes]"
    exit 1
fi

# Create timestamped note
TIMESTAMP=$(date +%Y%m%d-%H%M)
FILE="notes/sessions/${SESSION}-${TIMESTAMP}.org"

cat > "$FILE" << EOF
#+TITLE: Quick Note: ${SESSION}
#+DATE: $(date +%Y-%m-%d)
#+TIME: $(date +%H:%M)

* Quick Notes
${NOTES:-""}

* Follow-ups
EOF

echo "Created quick note at $FILE"
