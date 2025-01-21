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
