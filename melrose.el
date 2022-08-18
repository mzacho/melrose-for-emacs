;;; melrose.el --- Interact with Melrose for algorithmic melodies -*- lexical-binding: t; -*-

;; Copyright (C) 2022 reach@martinzacho.com

;; Author: Martin Zacho
;; Homepage: https://github.com/mzacho/melrose-for-emacs
;; Version: 0
;; Package-Version: 0.0.0
;; Package-Commit:
;; Keywords: music
;; Package-Requires: ()

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This mode is implemented as a derivation of `prog' mode,
;; indentation and font locking is courtesy that mode.  The
;; network communication is courtesy `url-handlers'.

;;; Code:

;; TODO : (require 'melrose-font-lock)

(defalias 'melrose-debug 'url-debug
  "*Debug the connection to the Melrose language server.")

(defvar melrose-buffer-name
  "*melrose*"
  "*The name of the melrose process buffer (default=*melrose*).")

(defvar melrose-command
  "melrose"
  "*The melrose program to use (default=melrose).")

(defvar melrose-command-arguments
  ()
  "*Arguments to melrose (default=none).")

(defvar melrose-tcp-server-hostname
  "localhost"
  "*Melrose langauge server hostname (default=localhost).")

(defvar melrose-tcp-server-port
  "8118"
  "*Melrose langauge server port (default=8118).")

(defvar melrose-tcp-server-version
  "v1"
  "*Melrose langauge server version (default=v1).")

(defun melrose--post-with-action (action path)
  "Sends a post request with ACTION to the language servers endpoint at PATH.
The body of the request is the current region, if selected, or otherwise the
current line."
  (let ((s (if mark-active
               (funcall region-extract-function nil)
               (buffer-substring (line-beginning-position)
			                     (line-end-position)))))
    (melrose--send-to-language-server s action path)
    (pulse-momentary-highlight-one-line (point))
    (deactivate-mark)))

(defun melrose--send-action-with-text (action selection text range)
  "Send ACTION SELECTION TEXT RANGE to the language server."
  )

(defun melrose-eval ()
  "Evaluate Melrose statement at current cursor position."
  (interactive)
  (melrose--post-with-action "eval" "statements"))

(defun melrose-eval-and-play ()
  "Play Melrose statement at current cursor position."
  (interactive)
  (melrose--post-with-action "play" "statements"))

(defun melrose-eval-and-stop ()
  "Evaluate Melrose statement at current cursor position and stop."
  (interactive)
  (melrose--post-with-action "stop" "statements"))

(defun melrose-kill ()
  "Stop all sounds and loops."
  (interactive)
  (melrose--post-with-action "kill" "statements"))

(defun melrose-eval-and-inspect ()
  "Evaluate Melrose statement and inspect the returned object."
  (interactive)
  (melrose--post-with-action "inspect"))

;;

(defun melrose--run-line (action path)
  "Post ACTION at the current line to the language servers PATH endpoint."
  (interactive)
  (let ((s (buffer-substring (line-beginning-position)
			      (line-end-position))))
    (melrose--send-to-language-server s action path))
  (pulse-momentary-highlight-one-line (point))
  (forward-line))

(defun melrose--send-to-language-server (body action path)
  "Post ACTION with BODY to the Melrose language servers PATH endpoint."
  (let*
      ((url-request-method "POST")
       (url-request-extra-headers
        '(("Content-Type" . "text/plain")))
       (url-request-data body)
       (url (concat "http://"
                    melrose-tcp-server-hostname ":"
                    melrose-tcp-server-port "/"
                    melrose-tcp-server-version "/"
                    path
                    "?debug=" (if url-debug "true" "false") "&"
                    "line=1" "&"
                    "action=" action "&"
                    "file=" (file-name-base (buffer-file-name))))
       (buffer (url-retrieve-synchronously url)))
    (with-current-buffer (get-buffer-create melrose-buffer-name)
      (url-insert-buffer-contents buffer url)
      (goto-char (point-min)))))

;; Todo : register hover provider

(defvar melrose-mode-map
  (let ((m (make-sparse-keymap)))
    ;; (unless (boundp 'electric-indent-chars)
    ;;   (define-key m "}" #'go-mode-insert-and-indent)
    ;;   (define-key m ")" #'go-mode-insert-and-indent))
    (define-key m (kbd "C-c C-e") #'melrose-eval)
    (define-key m (kbd "C-c C-p") #'melrose-eval-and-play)
    (define-key m (kbd "C-c C-s") #'melrose-eval-and-stop)
    (define-key m (kbd "C-c C-k") #'melrose-kill)
    (define-key m (kbd "C-c C-i") #'melrose-eval-and-inspect)
    m)
  "Keymap used by ‘melrose-mode’.")

;;;###autoload
(define-derived-mode
  melrose-mode
  prog-mode
  "Melrose"
  "Major mode for interacting with a Melrose Language Server."
  ;; (set (make-local-variable 'paragraph-start) "\f\\|[ \t]*$")
  ;; (set (make-local-variable 'paragraph-separate) "[ \t\f]*$")
  ;; (turn-on-font-lock)
  )

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.\\(?:mel\\|melrose\\)\\'" . melrose-mode))

(provide 'melrose)
;;; melrose.el ends here
