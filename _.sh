# Create Makefile for common tasks
cat > Makefile << 'EOL'
.PHONY: all clean sync backup

all: sync

clean:
	rm -f **/*~
	rm -f **/*.html

sync:
	git add .
	git commit -m "Auto-sync conference notes"

backup:
	tar czf ../popl-2025-backup.tar.gz .
EOL

# Create scripts directory
mkdir -p scripts

# Create helper script for paper downloads
cat > scripts/fetch-paper.sh << 'EOL'
#!/bin/bash
# Usage: ./fetch-paper.sh <paper-url> <output-name>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <paper-url> <output-name>"
    exit 1
fi

curl -L "$1" -o "papers/$2.pdf"
EOL

# Create helper script for session prep
cat > scripts/prep-session.sh << 'EOL'
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
EOL

chmod +x scripts/*.sh

git add .
git commit -m "Add Makefile and helper scripts"
