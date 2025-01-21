#!/bin/bash

# Create a papers management system
mkdir -p papers/{distinguished,interesting,followup}

# Create paper management script
cat > scripts/manage-paper.sh << 'END_PAPER'
#!/bin/bash

# Usage: ./manage-paper.sh <pdf_url> <category> <notes>
# Categories: distinguished, interesting, followup

URL="$1"
CATEGORY="$2"
NOTES="$3"
DATE=$(date +%Y%m%d)

if [ -z "$URL" ] || [ -z "$CATEGORY" ]; then
    echo "Usage: $0 <pdf_url> <category> [notes]"
    exit 1
fi

FILENAME="papers/${CATEGORY}/${DATE}-${URL##*/}"
curl -L "$URL" -o "$FILENAME"

# Create annotation template
cat > "${FILENAME%.*}.org" << EOF
#+TITLE: Paper Notes: ${URL##*/}
#+DATE: $(date +%Y-%m-%d)
#+CATEGORY: ${CATEGORY}

* Paper Overview
${NOTES:-"TBD"}

* Key Points
- 

* Implementation Ideas
- 

* Questions
- 

* Follow-ups
** Research Threads
** Related Work
** Potential Applications

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
EOF

echo "Paper downloaded to ${FILENAME}"
echo "Annotation template created at ${FILENAME%.*}.org"
END_PAPER
chmod +x scripts/manage-paper.sh

# Create pandoc template for paper exports
mkdir -p templates
cat > templates/paper.tex << 'END_TEX'
\documentclass[12pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{hyperref}
\usepackage{fontspec}
\usepackage{listings}
\usepackage{xcolor}

\title{POPL 2025 Paper Notes}
\author{Jason Walsh}
\date{\today}

\begin{document}
\maketitle

$body$

\end{document}
END_TEX

# Add paper management targets to Makefile
cat >> Makefile << 'END_MAKE'

# Paper management targets
.PHONY: papers-pdf papers-html papers-summary

papers-pdf:
	pandoc papers/**/*.org \
		--template=templates/paper.tex \
		--pdf-engine=xelatex \
		-o papers/summary.pdf

papers-html:
	pandoc papers/**/*.org \
		-o papers/summary.html \
		--standalone \
		--toc

papers-summary:
	@echo "Distinguished Papers:"
	@ls -1 papers/distinguished
	@echo "\nInteresting Papers:"
	@ls -1 papers/interesting
	@echo "\nFollow-up Papers:"
	@ls -1 papers/followup
END_MAKE

# Update README with paper management info
cat >> README.org << 'END_README'

* Paper Management
** Categories
- =distinguished/= - Distinguished papers
- =interesting/= - Papers for detailed review
- =followup/= - Papers for future reference

** Usage
Add a paper:
#+begin_src sh
./scripts/manage-paper.sh <pdf_url> distinguished "Summary notes"
#+end_src

Generate summaries:
#+begin_src sh
make papers-pdf   # Create PDF summary
make papers-html  # Create HTML summary
make papers-summary # List papers by category
#+end_src
END_README

git add .
git commit -m "Add paper management system and annotation tools"
git push origin main

echo "Added paper management system! Use scripts/manage-paper.sh to add papers."
