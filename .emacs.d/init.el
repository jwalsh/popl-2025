;; Initialize package system
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ensure we have use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Org mode setup
(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ocaml . t)
     (shell . t))))

;; OCaml support
(use-package tuareg
  :mode ("\\.ml[iyl]?\\'" . tuareg-mode)
  :config
  (setq tuareg-match-patterns-aligned t))

;; For better OCaml editing
(use-package merlin
  :hook (tuareg-mode . merlin-mode)
  :config
  (setq merlin-command 'opam))

;; Enable code block execution without confirmation
(setq org-confirm-babel-evaluate nil)

;; Better code block syntax highlighting
(setq org-src-fontify-natively t)

;; Add local lisp directory to load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Load track-papers package
(require 'track-papers)

;; Ensure we have OCaml environment variables set
(setenv "OCAML_VERSION" "4.14.0")
(setenv "OPAM_SWITCH_PREFIX" "/usr/local/opt/ocaml")

;; Custom functions for code block evaluation
(defun my/org-babel-execute-ocaml-or-elisp (arg)
  "Execute current code block if it's OCaml or Elisp."
  (interactive "P")
  (when (org-in-src-block-p)
    (let* ((info (org-babel-get-src-block-info))
           (lang (car info)))
      (when (member lang '("ocaml" "elisp" "ocaml-ts"))
        (org-babel-execute-src-block arg)))))