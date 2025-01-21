#!/bin/bash

# Create final emacs-lisp helper functions
mkdir -p lisp
cat > lisp/popl-helpers.el << 'END_ELISP'
;;; popl-helpers.el --- POPL 2025 Conference Note Helpers

;;; Commentary:
;; Helper functions for managing POPL 2025 conference notes

;;; Code:
(require 'org)
(require 'org-agenda)

(defun popl-2025/tag-session (tag)
  "Add TAG to current session heading."
  (interactive "sTag: ")
  (org-set-tags-to (cons tag (org-get-tags))))

(defun popl-2025/set-priority (priority)
  "Set PRIORITY ([#A] [#B] [#C]) for current heading."
  (interactive "cPriority [A/B/C]: ")
  (org-priority priority))

(defun popl-2025/generate-daily-agenda ()
  "Generate agenda for current day's sessions."
  (interactive)
  (let ((org-agenda-files '("notes")))
    (org-agenda nil "d")))

(defun popl-2025/mark-for-followup ()
  "Mark current item for follow-up."
  (interactive)
  (org-set-property "FOLLOW_UP" "t")
  (org-set-tags-to (cons "followup" (org-get-tags))))

(provide 'popl-helpers)
;;; popl-helpers.el ends here
END_ELISP

# Add init.el for easy loading
cat > init.el << 'END_INIT'
;; Load path for popl helpers
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'popl-helpers)

;; Org mode customizations
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

(setq org-tag-alist
      '(("ai" . ?a)
        ("verification" . ?v)
        ("wasm" . ?w)
        ("probabilistic" . ?p)
        ("followup" . ?f)))

;; Custom agenda views
(setq org-agenda-custom-commands
      '(("p" "POPL Overview"
         ((agenda "" ((org-agenda-span 'week)
                     (org-agenda-start-day "2025-01-19")))
          (tags "followup")
          (todo "TODO")))))
END_INIT

# Add a final README update
cat >> README.org << 'END_README'

* Emacs Configuration
** Setup
Add to your =init.el=:
#+begin_src emacs-lisp
(load "~/path/to/popl-2025/init.el")
#+end_src

** Available Commands
- =popl-2025/tag-session= - Tag current session
- =popl-2025/set-priority= - Set session priority
- =popl-2025/generate-daily-agenda= - View daily schedule
- =popl-2025/mark-for-followup= - Mark for follow-up

** Key Bindings
Suggested bindings:
#+begin_src emacs-lisp
(global-set-key (kbd "C-c p t") 'popl-2025/tag-session)
(global-set-key (kbd "C-c p p") 'popl-2025/set-priority)
(global-set-key (kbd "C-c p a") 'popl-2025/generate-daily-agenda)
(global-set-key (kbd "C-c p f") 'popl-2025/mark-for-followup)
#+end_src

* License
MIT
END_README

git add .
git commit -m "Add emacs-lisp helpers and final documentation"
git push origin main
