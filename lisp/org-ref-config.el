;;; org-ref-config.el --- Citation management configuration

(require 'org-ref)

(setq org-ref-bibliography-notes "notes/papers/"
      org-ref-default-bibliography '("bib/popl2025.bib")
      org-ref-pdf-directory "papers/")

(setq org-ref-completion-library 'org-ref-ivy-cite)

(provide 'org-ref-config)
