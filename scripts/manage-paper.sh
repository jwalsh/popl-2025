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
