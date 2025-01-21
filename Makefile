# Color output
CYAN := \033[36m
RESET := \033[0m

# Default target
.DEFAULT_GOAL := help

# Main targets
.PHONY: all clean sync backup init validate export watch serve test

# Show help
help:
	@echo -e "$(CYAN)Available targets:$(RESET)"
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "  ${CYAN}%-15s$(RESET) %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

# Run validation and sync
all: validate sync

# Remove generated files
clean:
	rm -f **/*~
	rm -f **/*.html
	rm -f **/*.pdf
	rm -rf dist/

# Sync with git repository
sync:
	git add .
	git commit -m "Auto-sync conference notes"
	git push

# Create dated backup
backup:
	$(eval DATE := $(shell date +%Y%m%d))
	tar czf ../popl-2025-backup-$(DATE).tar.gz .

# Initialize environment
init: validate
	@echo "Initializing environment..."
	@[ -f .envrc.local ] || cp .envrc.sample .envrc.local
	@direnv allow
	@poetry install

# Check environment setup
validate:
	@scripts/validate-env.sh

# Generate all exports (html, md, pdf)
export: html md pdf

# Generate HTML files
html:
	@echo "Generating HTML..."
	@emacs --batch \
		--eval "(require 'ox-html)" \
		--eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$$\")) \
			(with-current-buffer (find-file f) \
				(org-html-export-to-html)))"

# Generate Markdown files
md:
	@echo "Generating Markdown..."
	@emacs --batch \
		--eval "(require 'ox-md)" \
		--eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$$\")) \
			(with-current-buffer (find-file f) \
				(org-md-export-to-markdown)))"

# Generate PDF files
pdf:
	@echo "Generating PDFs..."
	@emacs --batch \
		--eval "(require 'ox-latex)" \
		--eval "(dolist (f (directory-files-recursively \"./notes\" \"\\.org$$\")) \
			(with-current-buffer (find-file f) \
				(org-latex-export-to-pdf)))"

# Watch for changes and auto-export
watch:
	@echo "Watching for changes..."
	@watchexec -w notes/ -w papers/ "make export"

# Start local server for exports
serve:
	@echo "Starting server on http://localhost:8000"
	@python -m http.server 8000 --directory dist/

# Docker operations
docker-build:
	docker-compose build

docker-export:
	docker-compose run --rm notes make export

docker-shell:
	docker-compose run --rm notes /bin/bash

# Generate all paper summaries
papers: papers-pdf papers-html papers-summary

# Generate PDF paper summary
papers-pdf:
	mkdir -p dist/papers
	pandoc papers/**/*.org \
		--template=templates/paper.tex \
		--pdf-engine=xelatex \
		-o dist/papers/summary.pdf

# Generate HTML paper summary
papers-html:
	mkdir -p dist/papers
	pandoc papers/**/*.org \
		-o dist/papers/summary.html \
		--standalone \
		--toc

# List paper categories
papers-summary:
	@echo -e "$(CYAN)Distinguished Papers:$(RESET)"
	@ls -1 papers/distinguished
	@echo -e "\n$(CYAN)Interesting Papers:$(RESET)"
	@ls -1 papers/interesting
	@echo -e "\n$(CYAN)Follow-up Papers:$(RESET)"
	@ls -1 papers/followup

# Bibliography management
bib: bib-check bib-format

# Validate bibliography
bib-check:
	biber --tool --validate-datamodel bib/popl2025.bib

# Format bibliography
bib-format:
	biber --tool --tool-resolve bib/popl2025.bib

# Run all tests
test:
	@echo "Running tests..."
	@poetry run pytest
	@scripts/check-setup.sh
