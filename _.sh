#!/bin/bash

# Create enhanced Makefile with auto-help
cat > Makefile << 'END_MAKEFILE'
# Color output
CYAN := \033[36m
RESET := \033[0m

# Default target
.DEFAULT_GOAL := help

# Main targets
.PHONY: all clean sync backup init validate export watch serve test

## make : Show this help
help:
   @echo -e "$(CYAN)Available targets:$(RESET)"
   @awk '/^[a-zA-Z\-_0-9]+:/ { \
   	helpMessage = match(lastLine, /^## (.*)/); \
   	if (helpMessage) { \
   		helpCommand = substr($$1, 0, index($$1, ":")-1); \
   		helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
   		printf "  ${CYAN}%-15s$(RESET) %s\n", helpCommand, helpMessage; \
   	} \
   } \
   { lastLine = $$0 }' $(MAKEFILE_LIST)

## all : Run validation and sync
all: validate sync

## clean : Remove generated files
clean:
   rm -f **/*~
   rm -f **/*.html
   rm -f **/*.pdf
   rm -rf dist/

## sync : Sync with git repository
sync:
   git add .
   git commit -m "Auto-sync conference notes"
   git push

## backup : Create dated backup
backup:
   $(eval DATE := $(shell date +%Y%m%d))
   tar czf ../popl-2025-backup-$(DATE).tar.gz .

## init : Initialize environment
init: validate
   @echo "Initializing environment..."
   @[ -f .envrc.local ] || cp .envrc.sample .envrc.local
   @direnv allow
   @poetry install

## validate : Check environment setup
validate:
   @scripts/validate-env.sh

## export : Generate all exports (html, md, pdf)
export: html md pdf

## html : Generate HTML files
html:
   @echo "Generating HTML..."
   @emacs --batch \
   	--eval "(require 'ox-html)" \
   	--eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$$\")) \
   		(with-current-buffer (find-file f) \
   			(org-html-export-to-html)))"

## md : Generate Markdown files
md:
   @echo "Generating Markdown..."
   @emacs --batch \
   	--eval "(require 'ox-md)" \
   	--eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$$\")) \
   		(with-current-buffer (find-file f) \
   			(org-md-export-to-markdown)))"

## pdf : Generate PDF files
pdf:
   @echo "Generating PDFs..."
   @emacs --batch \
   	--eval "(require 'ox-latex)" \
   	--eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$$\")) \
   		(with-current-buffer (find-file f) \
   			(org-latex-export-to-pdf)))"

## watch : Watch for changes and auto-export
watch:
   @echo "Watching for changes..."
   @watchexec -w notes/ -w papers/ "make export"

## serve : Start local server for exports
serve:
   @echo "Starting server on http://localhost:8000"
   @python -m http.server 8000 --directory dist/

## docker-build : Build Docker image
docker-build:
   docker-compose build

## docker-export : Run exports in Docker
docker-export:
   docker-compose run --rm notes make export

## docker-shell : Start Docker shell
docker-shell:
   docker-compose run --rm notes /bin/bash

## papers : Generate all paper summaries
papers: papers-pdf papers-html papers-summary

## papers-pdf : Generate PDF paper summary
papers-pdf:
   mkdir -p dist/papers
   pandoc papers/**/*.org \
   	--template=templates/paper.tex \
   	--pdf-engine=xelatex \
   	-o dist/papers/summary.pdf

## papers-html : Generate HTML paper summary
papers-html:
   mkdir -p dist/papers
   pandoc papers/**/*.org \
   	-o dist/papers/summary.html \
   	--standalone \
   	--toc

## papers-summary : List paper categories
papers-summary:
   @echo -e "$(CYAN)Distinguished Papers:$(RESET)"
   @ls -1 papers/distinguished
   @echo -e "\n$(CYAN)Interesting Papers:$(RESET)"
   @ls -1 papers/interesting
   @echo -e "\n$(CYAN)Follow-up Papers:$(RESET)"
   @ls -1 papers/followup

## bib : Run bibliography checks
bib: bib-check bib-format

## bib-check : Validate bibliography
bib-check:
   biber --tool --validate-datamodel bib/popl2025.bib

## bib-format : Format bibliography
bib-format:
   biber --tool --tool-resolve bib/popl2025.bib

## test : Run all tests
test:
   @echo "Running tests..."
   @poetry run pytest
   @scripts/check-setup.sh

.PHONY: help
END_MAKEFILE

git add Makefile
git commit -m "feat(make): Enhanced Makefile with auto-help and documentation

- Add colored help output
- Generate help from comments
- Improve target organization
- Add progress messages
- Set help as default target

For: Better developer experience"
git push origin main

echo -e "\033[36mEnhanced Makefile with auto-help - run 'make' to see available commands\033[0m"
