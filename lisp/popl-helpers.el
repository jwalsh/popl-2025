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
