;; track-papers.el --- Track papers and materials for POPL sessions -*- lexical-binding: t; -*-

(require 'org)
(require 'url)

(defvar popl-papers-directory
  (expand-file-name "papers" (projectile-project-root))
  "Directory for storing downloaded papers.")

(defvar popl-paper-metadata-file
  (expand-file-name "papers/paper-metadata.org" (projectile-project-root))
  "File for tracking paper metadata.")

(defun popl-ensure-directories ()
  "Ensure paper directories exist."
  (dolist (dir '("arxiv" "slides" "supplementary"))
    (make-directory (expand-file-name dir popl-papers-directory) t)))

(defun popl-add-paper-entry (title url local-path &optional notes)
  "Add a paper entry to the metadata file."
  (with-current-buffer (find-file-noselect popl-paper-metadata-file)
    (goto-char (point-max))
    (unless (bolp) (insert "\n"))
    (insert (format "* TODO %s\n" title))
    (insert ":PROPERTIES:\n")
    (insert (format ":URL: %s\n" url))
    (insert (format ":LOCAL_PATH: %s\n" local-path))
    (insert (format ":ADDED: %s\n" (format-time-string "[%Y-%m-%d %a %H:%M]")))
    (insert ":END:\n\n")
    (when notes
      (insert "** Notes\n")
      (insert notes "\n"))
    (save-buffer)))

(defun popl-download-arxiv-paper (arxiv-id)
  "Download paper from arXiv and track it."
  (interactive "sArXiv ID (e.g. 2411.07078): ")
  (let* ((url (format "https://arxiv.org/pdf/%s.pdf" arxiv-id))
         (local-path (format "papers/arxiv/%s.pdf" arxiv-id)))
    (url-copy-file url local-path t)
    (popl-add-paper-entry 
     (format "arXiv:%s" arxiv-id)
     url
     local-path)))

(defun popl-track-external-paper (url title)
  "Track an external paper URL."
  (interactive "sURL: \nsTitle: ")
  (let ((local-path (format "papers/external/%s.pdf" 
                           (replace-regexp-in-string "[^a-zA-Z0-9]" "-" title))))
    (popl-add-paper-entry title url local-path)))

(defun popl-insert-paper-link (paper-id)
  "Insert a link to a tracked paper."
  (interactive "sPaper ID: ")
  (insert (format "[[papers:%s][%s]]" paper-id paper-id)))

(provide 'track-papers)