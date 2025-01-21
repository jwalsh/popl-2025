#!/bin/bash

# Generate conference wrap-up report from notes
REPORT_FILE="reports/popl-2025-summary.org"
mkdir -p reports

cat > "$REPORT_FILE" << EOF
#+TITLE: POPL 2025 Conference Summary
#+DATE: $(date +%Y-%m-%d)
#+AUTHOR: Jason Walsh
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Conference Overview
** Key Themes
- AI System Verification
- WebAssembly Evolution
- Probabilistic Programming
- Proof Systems

** Technical Highlights
$(for f in notes/*.org; do
    echo "*** $(basename $f .org)"
    grep -A 2 "^\*\* Key" "$f" 2>/dev/null | sed 's/^/    /'
done)

** Action Items
$(grep -h "\[.\]" notes/*.org 2>/dev/null | sort -u | sed 's/^/- /')

** Follow-ups
$(grep -h "^** Papers to Read" -A 3 notes/*.org 2>/dev/null | sed 's/^/  /')

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
EOF

echo "Generated conference summary at $REPORT_FILE"
