#!/bin/bash

# Update Wednesday's schedule focusing on probabilistic programming
cat > notes/wednesday.org << 'END_WEDNESDAY'
#+TITLE: POPL 2025 - Wednesday (Probabilistic Programming)
#+OPTIONS: toc:2 num:nil
#+PROPERTY: header-args :tangle yes :mkdirp t

* Schedule :probabilistic:systems:
** Late Afternoon - POPL Track (Marco Polo)
*** [#A] 17:00-18:20 Probabilistic Programming 1
**** A quantitative probabilistic relational Hoare logic
:PROPERTIES:
:AUTHORS: Martin Avanzini, Gilles Barthe, Benjamin Gregoire, Davide Davoli
:INSTITUTIONS: Inria, MPI-SP
:ROOM: Marco Polo
:RELEVANCE: Formal verification of probabilistic systems
:END:
***** Key Points
- Focus on quantitative assertions
- Overcomes randomness alignment restrictions
***** Notes

**** [#A] Approximate Relational Reasoning for Higher-Order Probabilistic Programs
:PROPERTIES:
:AUTHORS: Philipp G. Haselwarter et al.
:INSTITUTIONS: Aarhus University, NYU
:RELEVANCE: Direct application to AI system verification
:END:
***** Key Points
- Higher-order approximate reasoning
- Integration with separation logic
***** Notes

**** [#B] Compositional imprecise probability
:PROPERTIES:
:AUTHORS: Jack Liell-Cock, Sam Staton
:INSTITUTION: University of Oxford
:RELEVANCE: Uncertainty handling in systems
:END:
***** Notes

* Key Questions
** Verification Approaches
- Integration with existing frameworks
- Scaling to production systems
- Handling uncertainty bounds

** Implementation Considerations
- Performance characteristics
- Integration patterns
- Tool support needed

* Follow-ups
** Papers to Read
- [#A] Approximate Relational Reasoning paper
- [#A] Quantitative Hoare logic paper for system verification

** People to Meet
- Gilles Barthe re: verification approaches
- Sam Staton re: compositional approaches

** Implementation Ideas
- Framework integration possibilities
- Verification pipeline enhancements

* Local Variables :noexport:
# Local Variables:
# org-confirm-babel-evaluate: nil
# End:
END_WEDNESDAY

# Add pre-commit hooks for org-mode validation
mkdir -p .git/hooks
cat > .git/hooks/pre-commit << 'END_HOOK'
#!/bin/bash

# Check org-mode syntax
for file in $(git diff --cached --name-only | grep '\.org$'); do
    if ! emacs --batch -l org --eval "(progn (find-file \"$file\") (org-lint))" 2>/dev/null; then
        echo "Org-mode validation failed for $file"
        exit 1
    fi
done
END_HOOK
chmod +x .git/hooks/pre-commit

git add .
git commit -m "Add Wednesday schedule with probabilistic programming focus and pre-commit hook"
git push origin main
