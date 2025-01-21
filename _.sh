#!/bin/bash

# Update tuesday.org with AI/LLM and verification focus
cat > notes/tuesday.org << 'EOL'
#+TITLE: POPL 2025 - Tuesday (AI/LLM Focus)
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Schedule :ai:llm:verification:
** Morning - PEPM Track (Dodgeball)
*** [#A] 11:00-12:30 High-level Abstraction
**** The Missing Diagonal: High Level Languages for Low Level Systems
:PROPERTIES:
:SPEAKER: Satnam Singh
:AFFILIATION: Groq
:ROOM: Dodgeball
:RELEVANCE: Systems architecture for AI
:END:
***** Notes

** Afternoon - PEPM/PADL Tracks
*** [#A] 13:00-14:30 Language Design (Dodgeball)
**** The Ethical Compiler
:PROPERTIES:
:SPEAKER: William J. Bowman
:AFFILIATION: University of British Columbia
:ROOM: Dodgeball
:RELEVANCE: AI system safety
:END:
***** Notes

*** [#A] 16:00-17:30 AI Integration (Duck, Duck Goose)
**** Leveraging LLM Reasoning with Dual Horn Programs
:PROPERTIES:
:SPEAKER: Paul Tarau
:AFFILIATION: University of North Texas
:ROOM: Duck, Duck Goose
:RELEVANCE: Core AI systems integration
:END:
***** Notes

**** [#A] Cyber Threat Detection with ASP
:PROPERTIES:
:AUTHORS: Fang Li, Fei Zuo, Gopal Gupta
:ROOM: Duck, Duck Goose
:RELEVANCE: Security architecture
:END:
***** Notes

*** [#A] 18:00-19:30 LLM Panel (Dodgeball)
**** Semantics-based program manipulation in the age of LLMs
:PROPERTIES:
:PANELISTS: William J. Bowman, Brigitte Pientka, Satnam Singh, Sam Lindley
:ROOM: Dodgeball
:RELEVANCE: Direct relevance to AI systems work
:END:
***** Panel Topics
- LLM integration patterns
- Verification approaches
- Safety considerations
***** Notes

* Key Questions
** LLM Integration
- Verification approaches for LLM components
- Safety guarantees in hybrid systems
- Integration patterns with formal methods

** System Architecture
- Scalability of verification approaches
- Performance characteristics
- Security boundaries

* Follow-ups
** Papers to Read
- Dual Horn Programs paper for LLM reasoning
- Ethical Compiler paper for safety considerations

** People to Meet
- Paul Tarau re: LLM reasoning
- Panel members for AI systems discussion

** Implementation Ideas
- LLM verification framework extensions
- Safety pattern implementation

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
EOL

git add .
git commit -m "Add Tuesday schedule with AI/LLM focus"
