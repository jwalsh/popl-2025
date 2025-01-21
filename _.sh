#!/bin/bash

# Remove backup and temp files
rm -f **/*.bak **/*~ "#"*"#"

# Create a sessions directory for generated content
mkdir -p notes/sessions

# Add a .gitignore entry for temp files
cat >> .gitignore << 'END_IGNORE'
# Backup files
*.bak
*~
\#*\#
.#*

# Generated content
notes/sessions/*
reports/*

# Local config
.dir-locals.el
END_IGNORE

# Add directory-local variables for Emacs
cat > .dir-locals.el << 'END_LOCALS'
((org-mode . ((org-tags-column . -60)
              (org-log-into-drawer . t)
              (org-startup-folded . overview)
              (org-refile-use-outline-path . t))))
END_LOCALS

# Create symlinks for common paths
ln -sf notes/sessions sessions
ln -sf updates/room-changes.org ROOMS.org

# Add integration script for Discord notifications
cat > scripts/notify-updates.sh << 'END_NOTIFY'
#!/bin/bash

WEBHOOK_URL="${DISCORD_WEBHOOK_URL}"

if [ -z "$WEBHOOK_URL" ]; then
    echo "Set DISCORD_WEBHOOK_URL environment variable first"
    exit 1
fi

MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <message>"
    exit 1
fi

curl -H "Content-Type: application/json" \
     -d "{\"content\": \"$MESSAGE\"}" \
     "$WEBHOOK_URL"
END_NOTIFY
chmod +x scripts/notify-updates.sh

# Update README with latest changes
cat >> README.org << 'END_README'

* Quick Access
- Room changes: [[file:ROOMS.org][ROOMS.org]]
- Session notes: [[file:sessions][sessions/]]

* Scripts
** notify-updates.sh
Send updates to Discord:
#+begin_src sh
export DISCORD_WEBHOOK_URL="..."
./scripts/notify-updates.sh "Room change: PEPM moved to Scissors (2nd floor)"
#+end_src

** room-finder.sh
Find session locations:
#+begin_src sh
./scripts/room-finder.sh "Scissors"
#+end_src
END_README

# Clean up and commit
git clean -f
git add .
git commit -m "Clean up repository structure and add integrations"
git push origin main

echo "Repository cleanup complete and integrations added!"
