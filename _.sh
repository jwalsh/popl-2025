#!/bin/bash

# Add org capture templates for quick session notes
cat > lisp/popl-capture-templates.el << 'END_CAPTURE'
;;; popl-capture-templates.el --- Quick capture templates for POPL 2025

(require 'org-capture)

(setq org-capture-templates
      `(("s" "Session Note" entry
         (file+headline "notes/sessions/${slug}.org" "Notes")
         ,(concat "* %^{Title}\n"
                 ":PROPERTIES:\n"
                 ":ROOM: %^{Room}\n"
                 ":TIME: %^{Time}\n"
                 ":SPEAKERS: %^{Speakers}\n"
                 ":END:\n\n"
                 "%?"))
        ("p" "Paper Note" entry
         (file+headline "papers/notes/${title}.org" "Notes")
         ,(concat "* %^{Title}\n"
                 ":PROPERTIES:\n"
                 ":AUTHORS: %^{Authors}\n"
                 ":PAPER_LINK: %^{Link}\n"
                 ":READ_DATE: %t\n"
                 ":END:\n\n"
                 "** Summary\n%?\n"
                 "** Key Points\n\n"
                 "** Implementation Ideas\n"))))

(provide 'popl-capture-templates)
END_CAPTURE

# Add helper script for quick note taking
cat > scripts/quick-note.sh << 'END_QUICK'
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
END_QUICK
chmod +x scripts/quick-note.sh

# Update init.el to load capture templates
echo '(require '"'"'popl-capture-templates)' >> init.el

# Add to README
cat >> README.org << 'END_README'

* Quick Notes
** Capture Templates
Quick note capture with =C-c c=:
- =s= Session note
- =p= Paper note

** Command Line
Quick notes from terminal:
#+begin_src sh
./scripts/quick-note.sh "ethical-compiler" "Interesting points about type safety"
#+end_src
END_README

git add .
git commit -m "feat(notes): Add quick capture templates and CLI note taking

- Add org-capture templates for sessions and papers
- Add quick-note.sh for CLI note taking
- Update documentation with quick note features

Related: Session and paper note taking workflow"
git push origin main

echo "Added quick note taking features!"
