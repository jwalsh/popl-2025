;; Load path for popl helpers
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(add-to-list 'load-path (expand-file-name "lisp"))
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
(require 'org-ref-config)
(require 'popl-capture-templates)
