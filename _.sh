#!/bin/bash

# Create a room change manifest
cat > updates/2025-01-21-room-manifest.org << 'END_MANIFEST'
#+TITLE: Room Changes - January 21, 2025
#+PROPERTY: header-args :tangle yes :mkdirp t

* Current Room Assignments :rooms:2ndfloor:
** Tutorial Track
- Location: Paper Room (2nd Floor)
- Previously: Goose
- Sessions:
  - 11:00-12:30 Stateless Model Checking
  - 13:00-14:30 Stateless Model Checking (continued)

** PEPM Track
- Location: Scissors Room (2nd Floor)
- Previously: Dodgeball
- Key Sessions:
  - 11:00-12:30 High-level abstraction
  - 13:00-14:30 Language design
  - 16:00-17:30 Types and meta theory
  - 18:00-19:30 Macros and LLMs

** PADL Track
- Location: Keep Away Room (2nd Floor)
- Previously: Duck, Duck Goose
- Key Sessions:
  - 16:00-17:30 LLM & ASP Session

* Navigation Notes :navigation:
** 2nd Floor Layout
- All relocated sessions are on 2nd floor
- Follow posted signs
- Some hallways closed due to water damage
- Use main stairwell/elevator for access

** Quick Reference
| Track    | Room      | Notable Session                    | Time        |
|----------+-----------+-----------------------------------+-------------|
| Tutorial | Paper     | Stateless Model Checking          | 11:00-14:30 |
| PEPM     | Scissors  | LLM Panel                         | 18:45-19:25 |
| PADL     | Keep Away | LLM Reasoning with Horn Programs  | 16:30-17:00 |

* Follow-up Actions :admin:
- Updated all schedule files
- Room signs in place
- Directional signs posted
- Staff briefed on changes

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
END_MANIFEST

# Update Tuesday's schedule specifically
cat > notes/tuesday.org << 'END_TUESDAY'
#+TITLE: POPL 2025 - Tuesday (AI/LLM Focus)
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Schedule :ai:llm:verification:
** Morning - [NEW] Tutorial Track (Paper Room, 2nd Floor) :tutorial:
*** [#A] 11:00-12:30 Stateless Model Checking
:PROPERTIES:
:ROOM: Paper (2nd Floor)
:SPEAKERS: Michalis Kokologiannakis, Viktor Vafeiadis
:INSTITUTIONS: ETH Zurich, MPI-SWS
:END:
**** Notes

** Afternoon - PEPM Track (Scissors Room, 2nd Floor) :pepm:
*** [#A] 13:00-14:30 Language Design
**** The Ethical Compiler
:PROPERTIES:
:SPEAKER: William J. Bowman
:ROOM: Scissors (2nd Floor)
:RELEVANCE: AI system safety
:END:
**** Notes

*** [#A] 16:00-17:30 AI Integration (Keep Away Room, 2nd Floor) :padl:
**** Leveraging LLM Reasoning with Dual Horn Programs
:PROPERTIES:
:SPEAKER: Paul Tarau
:ROOM: Keep Away (2nd Floor)
:RELEVANCE: Core AI systems integration
:END:
**** Notes

*** [#A] 18:00-19:30 LLM Panel (Scissors Room) 
**** Semantics-based program manipulation in the age of LLMs
:PROPERTIES:
:PANELISTS: William J. Bowman, Brigitte Pientka, Satnam Singh, Sam Lindley
:ROOM: Scissors (2nd Floor)
:RELEVANCE: Direct relevance to AI systems work
:END:

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
END_TUESDAY

# Create a simple room finder script
cat > scripts/room-finder.sh << 'END_FINDER'
#!/bin/bash

ROOM="$1"
TIME="$2"

if [ -z "$ROOM" ]; then
    echo "Usage: $0 <room> [time]"
    echo "Available rooms: Paper, Scissors, Keep Away"
    exit 1
fi

grep -r -i "$ROOM" notes/ updates/ | grep -i "${TIME:-''}"
END_FINDER
chmod +x scripts/room-finder.sh

git add .
git commit -m "Update room assignments and add navigation helpers for January 21 changes"
git push origin main
