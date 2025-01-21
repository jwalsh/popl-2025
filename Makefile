.PHONY: all clean sync backup

all: sync

clean:
	rm -f **/*~
	rm -f **/*.html

sync:
	git add .
	git commit -m "Auto-sync conference notes"

backup:
	tar czf ../popl-2025-backup.tar.gz .

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
		--eval "(dolist (f (directory-files-recursively \"./\" \"

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

# Docker targets
.PHONY: docker-build docker-export docker-shell

docker-build:
	docker-compose build

docker-export:
	docker-compose run --rm notes

docker-shell:
	docker-compose run --rm notes /bin/bash

# Paper management targets
.PHONY: papers-pdf papers-html papers-summary

papers-pdf:
	pandoc papers/**/*.org \
		--template=templates/paper.tex \
		--pdf-engine=xelatex \
		-o papers/summary.pdf

papers-html:
	pandoc papers/**/*.org \
		-o papers/summary.html \
		--standalone \
		--toc

papers-summary:
	@echo "Distinguished Papers:"
	@ls -1 papers/distinguished
	@echo "\nInteresting Papers:"
	@ls -1 papers/interesting
	@echo "\nFollow-up Papers:"
	@ls -1 papers/followup

# Citation management
.PHONY: bib-check bib-format

bib-check:
	biber --tool --validate-datamodel bib/popl2025.bib

bib-format:
	biber --tool --tool-resolve bib/popl2025.bib

