;;; popl-capture-templates.el --- Quick capture templates for POPL 2025

(require 'org-capture)

(setq org-capture-templates
      `(("s" "Session Note" entry
         (file+headline "notes/sessions/${slug}.org" "Notes")
         ,(concat "* %^{Title}\n"
                 ":PROPERTIES:\n"
                 ":ROOM: %^{Room}\n"
                 ":TIME: %^{Time}\n"
                 ":SPEAKERS: %^{Speakers}\n"
                 ":END:\n\n"
                 "%?"))
        ("p" "Paper Note" entry
         (file+headline "papers/notes/${title}.org" "Notes")
         ,(concat "* %^{Title}\n"
                 ":PROPERTIES:\n"
                 ":AUTHORS: %^{Authors}\n"
                 ":PAPER_LINK: %^{Link}\n"
                 ":READ_DATE: %t\n"
                 ":END:\n\n"
                 "** Summary\n%?\n"
                 "** Key Points\n\n"
                 "** Implementation Ideas\n"))))

(provide 'popl-capture-templates)
