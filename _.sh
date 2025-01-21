#!/bin/bash

# Create GitHub Actions directory
mkdir -p .github/workflows .github/PULL_REQUEST_TEMPLATE

# Create org-export action
cat > .github/workflows/org-export.yml << 'END_WORKFLOW'
name: Org Export

on:
  push:
    branches: [ main ]
    paths:
      - '**.org'
  pull_request:
    branches: [ main ]
    paths:
      - '**.org'

jobs:
  export:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Emacs
        uses: purcell/setup-emacs@master
        with:
          version: 28.2
          
      - name: Export Org files
        run: |
          emacs --batch \
            --eval "(progn \
              (require 'ox-md) \
              (require 'org) \
              (dolist (f (directory-files-recursively \"./\" \"\\.org$\")) \
                (with-current-buffer (find-file f) \
                  (org-md-export-to-markdown))))"

      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add *.md
          git commit -m "Auto-generate markdown from org files" || echo "No changes to commit"
          git push
END_WORKFLOW

# Create PR template
cat > .github/PULL_REQUEST_TEMPLATE/pull_request_template.md << 'END_PR'
## Description
Brief description of the changes

## Type of change
- [ ] Conference notes
- [ ] Paper summaries
- [ ] Implementation ideas
- [ ] Documentation
- [ ] Other

## Related Issues
Fixes # (issue)

## Additional context
Add any other context about the PR here
END_PR

# Add contributing guidelines
cat > CONTRIBUTING.md << 'END_CONTRIB'
# Contributing to POPL 2025 Notes

## Structure
- Use org-mode for all notes
- Follow existing templates in scripts/templates
- Include session metadata in PROPERTIES drawers

## Pull Requests
- Create feature branches
- Use meaningful commit messages
- Add paper references where applicable
END_CONTRIB

# Update Makefile with export targets
cat >> Makefile << 'END_MAKE'

# Export targets
.PHONY: html md all-exports

# Generate HTML from org files
html:
	emacs --batch \
		--eval "(require 'ox-html)" \
		--eval "(dolist (f (directory-files-recursively \"./\" \"\\.org$$\")) \
			(with-current-buffer (find-file f) \
				(org-html-export-to-html)))"

# Export to markdown
md:
	emacs --batch \
		--eval "(require 'ox-md)" \
		--eval "(dolist (f (directory-files-recursively \"./\" \"\\.org$$\")) \
			(with-current-buffer (find-file f) \
				(org-md-export-to-markdown)))"

# Run all exports
all-exports: html md
END_MAKE

git add .
git commit -m "Add GitHub Actions and contribution guidelines"
git push origin main

echo "GitHub Actions and guidelines added successfully!"
