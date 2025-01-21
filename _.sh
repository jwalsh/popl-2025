#!/bin/bash

# Update monday.org with WAW track details
cat > notes/monday.org << 'EOL'
#+TITLE: POPL 2025 - Monday (WAW Track)
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Schedule :wasm:systems:
** Morning - WAW Track (Dodgeball) 
*** [#A] 11:00-12:30 Session 1
**** Full-Stack Correctness in Wasm: Eliminating Bugs Inside and Outside the Sandbox
:PROPERTIES:
:SPEAKER: Chris Fallin
:AFFILIATION: F5
:ROOM: Dodgeball
:TRACK: WAW
:END:
***** Notes

*** [#A] 13:00-14:30 Session 2 
**** Adventures in Making Wasm Fast and More Secure
:PROPERTIES:
:SPEAKER: Shravan Ravi Narayan
:ROOM: Dodgeball
:TRACK: WAW
:END:
***** Notes

** Afternoon - WAW Track (Dodgeball)
*** [#B] 16:00-17:30 Session 3
**** Experience Report: Stack Switching in Wasm SpecTec
:PROPERTIES:
:AUTHORS: Yalun Liang, Sam Lindley, Andreas Rossberg
:ROOM: Dodgeball
:END:
***** Notes

*** [#A] 18:00-19:30 Session 4
**** The WebAssembly Component Model
:PROPERTIES:
:AUTHORS: Lucy Menon, Luke Wagner
:AFFILIATION: Microsoft, Fastly
:ROOM: Dodgeball
:END:
***** Notes

* Questions to Ask
** Component Model
- Integration strategies with existing systems
- Performance characteristics
- Security boundaries

** Stack Switching
- Implementation challenges
- Use cases in production

* Follow-ups
** Papers to Read
- Full-Stack Correctness paper
- Component Model spec

** People to Meet
- Chris Fallin re: system verification
- WebAssembly Working Group members

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
EOL

# Add empty template files for scripts dir
mkdir -p scripts/templates
cat > scripts/templates/session.org << 'EOL'
#+TITLE: POPL 2025 - %SESSION%
#+DATE: %DATE%
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Session Overview
:PROPERTIES:
:TRACK: 
:ROOM: 
:TIME: 
:END:

* Notes

* Questions Asked

* Action Items

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
EOL

# Add paper template
cat > scripts/templates/paper.org << 'EOL'
#+TITLE: Paper Notes: %TITLE%
#+DATE: %DATE%
#+AUTHOR: Jason Walsh
#+PROPERTY: header-args :tangle yes :mkdirp t

* Overview
:PROPERTIES:
:AUTHORS: %AUTHORS%
:CONFERENCE: POPL 2025
:TRACK: %TRACK%
:END:

* Key Points

* Questions

* Implementation Ideas

* Follow-ups
** Research Threads
** Related Papers
** Potential Applications

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
EOL

git add .
git commit -m "Add Monday schedule and templates"
