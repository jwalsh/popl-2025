#!/bin/bash

# Add Thursday's schedule focusing on verification and decision procedures
cat > notes/thursday.org << 'END_THURSDAY'
#+TITLE: POPL 2025 - Thursday (Verification & Probabilistic)
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Schedule :verification:probabilistic:
** Early Afternoon - POPL Track (Marco Polo)
*** [#A] 12:40-14:00 Probabilistic Programming 2
**** Inference Plans for Hybrid Particle Filtering
:PROPERTIES:
:AUTHORS: Ellie Y. Cheng et al.
:INSTITUTIONS: MIT, IBM Research
:ROOM: Marco Polo
:RELEVANCE: Practical probabilistic inference
:END:
***** Key Points
- Hybrid particle filtering
- Performance optimization approaches
***** Notes

**** [#A] Guaranteed Bounds on Posterior Distributions (Distinguished Paper)
:PROPERTIES:
:AUTHORS: Fabian Zaiser, Andrzej Murawski, C.-H. Luke Ong
:INSTITUTION: University of Oxford
:RELEVANCE: Critical for AI system guarantees
:DISTINGUISHED: yes
:END:
***** Key Points
- Automated bound computation
- Loop handling
***** Notes

*** [#A] 15:20-16:20 Decision Procedures
**** A Primal-Dual Perspective on Program Verification (Distinguished Paper)
:PROPERTIES:
:AUTHORS: Takeshi Tsukada, Hiroshi Unno, Oded Padon, Sharon Shoham
:RELEVANCE: Core verification methodology
:DISTINGUISHED: yes
:END:
***** Key Points
- Unified verification framework
- Practical algorithm development
***** Notes

**** Dis/Equality Graphs
:PROPERTIES:
:AUTHORS: George Zakhour et al.
:INSTITUTION: University of St. Gallen
:RELEVANCE: Program analysis infrastructure
:END:
***** Notes

* Key Questions
** Verification Frameworks
- Integration with existing tools
- Scaling characteristics
- Real-world applicability

** Probabilistic Systems
- Bound computation strategies
- Performance implications
- Integration patterns

* Follow-ups
** Papers to Read
- [#A] Both Distinguished Papers
- [#B] Particle filtering implementation

** People to Meet
- Oxford team re: bounds computation
- Verification framework authors

** Implementation Ideas
- Bound computation integration
- Verification pipeline enhancement

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
END_THURSDAY

# Add a script to fetch paper PDFs based on DOI
cat > scripts/fetch-papers.sh << 'END_PAPER_SCRIPT'
#!/bin/bash

# Usage: ./fetch-papers.sh <doi>
# Fetches paper PDFs and creates annotation templates

DOI="$1"
if [ -z "$DOI" ]; then
    echo "Usage: $0 <doi>"
    exit 1
fi

PAPER_DIR="papers/$(echo $DOI | tr '/' '_')"
mkdir -p "$PAPER_DIR"

# Create annotation template
cat > "$PAPER_DIR/notes.org" << EOF
#+TITLE: Paper Notes: $DOI
#+DATE: $(date +%Y-%m-%d)
#+PROPERTY: header-args :tangle yes :mkdirp t

* Paper Overview
:PROPERTIES:
:DOI: $DOI
:READ_DATE: $(date +%Y-%m-%d)
:END:

* Key Points

* Implementation Notes

* Questions

* Follow-ups
EOF

echo "Created annotation template in $PAPER_DIR"
END_PAPER_SCRIPT
chmod +x scripts/fetch-papers.sh

git add .
git commit -m "Add Thursday schedule with verification focus and paper fetching script"
git push origin main
