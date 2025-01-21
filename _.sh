#!/bin/bash

# Create bibliography directory and main bib file
mkdir -p bib
cat > bib/popl2025.bib << 'END_BIB'
% POPL 2025 Bibliography

@conference{POPL2025,
  title     = {POPL 2025: 52nd ACM SIGPLAN Symposium on Principles of Programming Languages},
  booktitle = {POPL 2025},
  year      = {2025},
  address   = {Denver, Colorado},
  month     = {January},
  publisher = {ACM}
}

% Distinguished Papers
@inproceedings{zaiser2025guaranteed,
  title     = {Guaranteed Bounds on Posterior Distributions of Discrete Probabilistic Programs with Loops},
  author    = {Zaiser, Fabian and Murawski, Andrzej and Ong, C.-H. Luke},
  booktitle = {POPL 2025},
  year      = {2025},
  note      = {Distinguished Paper}
}
END_BIB

# Create citation management script
cat > scripts/cite-paper.sh << 'END_CITE'
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
END_CITE
chmod +x scripts/cite-paper.sh

# Add org-ref configuration
cat > lisp/org-ref-config.el << 'END_ORG_REF'
;;; org-ref-config.el --- Citation management configuration

(require 'org-ref)

(setq org-ref-bibliography-notes "notes/papers/"
      org-ref-default-bibliography '("bib/popl2025.bib")
      org-ref-pdf-directory "papers/")

(setq org-ref-completion-library 'org-ref-ivy-cite)

(provide 'org-ref-config)
END_ORG_REF

# Update init.el
echo '(require '"'"'org-ref-config)' >> init.el

# Add citation targets to Makefile
cat >> Makefile << 'END_MAKE'

# Citation management
.PHONY: bib-check bib-format

bib-check:
	biber --tool --validate-datamodel bib/popl2025.bib

bib-format:
	biber --tool --tool-resolve bib/popl2025.bib

END_MAKE

git add .
git commit -m "Add citation management and BibTeX integration"
git push origin main

echo "Added citation management! Use scripts/cite-paper.sh to add citations."
