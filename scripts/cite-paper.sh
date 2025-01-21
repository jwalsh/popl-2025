#!/bin/bash

# Usage: ./cite-paper.sh "Author" "Title" "Distinguished" "Notes"

AUTHOR="$1"
TITLE="$2"
DISTINGUISHED="$3"
NOTES="$4"

if [ -z "$AUTHOR" ] || [ -z "$TITLE" ]; then
    echo "Usage: $0 'Author' 'Title' [Distinguished] [Notes]"
    exit 1
fi

# Generate BibTeX key
KEY=$(echo "$AUTHOR" | cut -d' ' -f2 | tr '[:upper:]' '[:lower:]')${TITLE:0:4}2025
KEY=$(echo "$KEY" | sed 's/[^a-z0-9]//g')

cat >> bib/popl2025.bib << EOF

@inproceedings{${KEY},
  title     = {${TITLE}},
  author    = {${AUTHOR}},
  booktitle = {POPL 2025},
  year      = {2025}$([ ! -z "$DISTINGUISHED" ] && echo ",
  note      = {Distinguished Paper}")
}
EOF

# Add to org notes if provided
if [ ! -z "$NOTES" ]; then
    cat > "notes/papers/${KEY}.org" << EOF
#+TITLE: Notes: ${TITLE}
#+CITE: @${KEY}
#+DATE: $(date +%Y-%m-%d)

* Overview
${NOTES}

* Citation
#+begin_src bibtex
@inproceedings{${KEY},
  title     = {${TITLE}},
  author    = {${AUTHOR}},
  booktitle = {POPL 2025},
  year      = {2025}$([ ! -z "$DISTINGUISHED" ] && echo ",
  note      = {Distinguished Paper}")
}
#+end_src

* Notes
EOF
fi

echo "Added citation ${KEY} to bibliography"
