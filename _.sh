#!/bin/bash

# Add Friday's schedule focusing on proof systems and final verification sessions
cat > notes/friday.org << 'END_FRIDAY'
#+TITLE: POPL 2025 - Friday (Proof Systems)
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Schedule :proofs:verification:
** Afternoon - POPL Track (Marco Polo)
*** [#A] 15:20-16:20 Verification 2
**** Archmage and CompCertCast: End-to-End Verification
:PROPERTIES:
:AUTHORS: Yonghyun Kim et al.
:INSTITUTION: Seoul National University
:ROOM: Marco Polo
:RELEVANCE: Complete system verification pipeline
:END:
***** Key Points
- Integer-pointer casting support
- End-to-end verification
- Framework integration
***** Notes

**** [#B] Formalising Graph Algorithms with Coinduction
:PROPERTIES:
:AUTHORS: Donnacha Oisín Kidney, Nicolas Wu
:INSTITUTIONS: Imperial College London
:ROOM: Marco Polo
:END:
***** Notes

*** [#A] 19:00-20:00 Proof Assistants (Peek-A-Boo)
**** Progressful Interpreters for WebAssembly
:PROPERTIES:
:AUTHORS: Xiaojia Rao et al.
:INSTITUTIONS: Imperial College London, NTU
:ROOM: Peek-A-Boo
:RELEVANCE: Direct application to Wasm work
:END:
***** Key Points
- Certified verification
- Performance optimization
***** Notes

**** Unifying compositional verification
:PROPERTIES:
:AUTHORS: Yu Zhang et al.
:INSTITUTIONS: Yale University
:RELEVANCE: System-wide verification approach
:END:
***** Notes

* Implementation Focus
** Verification Integration
- CompCertCast integration possibilities
- WebAssembly verification pipeline
- Compositional approaches

** Framework Development
- Tool integration patterns
- Performance considerations
- Safety guarantees

* Key Questions
** Technical Deep Dives
- CompCertCast implementation details
- WebAssembly interpreter certification
- Verification scaling approaches

** Integration Strategies
- Framework combination approaches
- Tool integration patterns
- Performance implications

* Conference Wrap-up
** Key Takeaways
- Verification framework advances
- WebAssembly ecosystem development
- AI system verification approaches

** Action Items
- [ ] Framework integration investigation
- [ ] Tool evaluation for immediate use
- [ ] Follow-up with key contacts

** Research Directions
- System-wide verification approaches
- AI/ML system certification
- Performance optimization patterns

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
END_FRIDAY

# Add a script for conference wrap-up report generation
cat > scripts/generate-report.sh << 'END_REPORT_SCRIPT'
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
END_REPORT_SCRIPT
chmod +x scripts/generate-report.sh

git add .
git commit -m "Add Friday schedule and conference report generator"
git push origin main
