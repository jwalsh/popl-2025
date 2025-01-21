#!/bin/bash

# Create room change tracking
mkdir -p updates

# Log the room changes
cat > updates/room-changes.org << 'END_CHANGES'
#+TITLE: POPL 2025 Room Changes
#+DATE: 2025-01-21
#+PROPERTY: header-args :tangle yes :mkdirp t

* Room Changes [2025-01-21]
:PROPERTIES:
:NOTICE_DATE: [2025-01-21 Tue]
:REASON: Water damage
:END:

** Affected Tracks
| Track       | Old Room    | New Room  | Floor |
|-------------+-------------+-----------+-------|
| PADL        | Duck, Duck  | Keep Away | 2nd   |
| Tutorial    | Goose       | Paper     | 2nd   |
| PEPM        | Dodgeball   | Scissors  | 2nd   |

** Impact on Schedule
- No changes to timing
- Hallway access limited
- Signs will be posted

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
END_CHANGES

# Update affected schedule files
for f in notes/{tuesday,wednesday,thursday,friday}.org; do
    sed -i.bak \
        -e 's/Duck, Duck Goose/Keep Away/g' \
        -e 's/Dodgeball/Scissors/g' \
        "$f"
done

# Add room change notice to README
cat >> README.org << 'END_UPDATE'

* Updates :notice:
** [2025-01-21] Room Changes
Due to water damage, the following rooms have been relocated:
- PADL → Keep Away (2nd floor)
- Tutorial Fest → Paper (2nd floor)
- PEPM → Scissors (2nd floor)

See =updates/room-changes.org= for details.
END_UPDATE

git add .
git commit -m "Update room assignments due to water damage"
git push origin main

echo "Room changes updated! Check updates/room-changes.org for details."
