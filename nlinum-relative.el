;;; nlinum-relative.el --- Relative line number with nlinum  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  codefalling

;; Author: codefalling <code.falling@gmail.com>
;; Keywords: convenience

;; Version: 0.1
;; Package-Requires: ((nlinum "1.5"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'nlinum)

(defgroup nlinum-relative nil
  "Show relative line numbers with nlinum."
  :group 'convenience)

(defcustom nlinum-relative-current-symbol "->"
  "The symbol you want to show on the current line, by default it is empty.
   You can use any string like \"->\". If this variable is empty string,
nlinum-releative will show the real line number at current line."
  :type 'string
  :group 'nlinum-relative)

(defcustom nlinum-relative-redisplay-delay 0.1
  "nlinum-relative-mode only redisplay when idle with a delay, default value is 0.1"
  :type 'number
  :group 'nlinum-relative)

(defvar nlinum-relative-current--line 0
  "Store current line number before jit-lock.")
(make-variable-buffer-local 'nlinum-relative-current--line)

(defvar nlinum-relative--store-format-function nlinum-format-function
  "Store old `nlinum-relative-format-function'")

(defvar nlinum-relative--format-function
  (lambda (line width)
    (let* ((line-display (abs (- line nlinum-relative--current-line) ))
           (is-current-line? (eq line-display 0))
           (line-display (if is-current-line? nlinum-relative--current-line line-display))
           (str (if (and (not (string-equal nlinum-relative-current-symbol "")) is-current-line?)
                    nlinum-relative-current-symbol (format nlinum-format line-display)))
          )
      (when (< (length str) width)
        ;; Left pad to try and right-align the line-numbers.
        (setq str (concat (make-string (- width (length str)) ?\ ) str)))
      (put-text-property 0 width 'face 'linum str)
      str))
  "nlinum-relative to replace nlinum-format-function")


(defun nlinum-relative--save-current-line (begin end)
  "Save current line before jit-lock"
  (when nlinum-relative-mode
    (setq nlinum-relative--current-line (line-number-at-pos))
    ))

(defvar nlinum-relative--timer nil)
(make-local-variable 'nlinum-relative--timer)

(defun nlinum-relative-on ()
  "Turn ON nlinum-relative."
  (advice-add 'jit-lock-fontify-now :before #'nlinum-relative--save-current-line)
  (setq nlinum-format-function nlinum-relative--format-function)
  (setq nlinum-relative--timer (run-with-idle-timer nlinum-relative-redisplay-delay t '(lambda () (font-lock-fontify-buffer))))
  )

(defun nlinum-relative-off ()
  "Turn OFF nlinum-relative."
  (advice-remove 'jit-lock-fontify-now #'nlinum-relative--save-current-line)
  (setq nlinum-format-function nlinum-relative--store-format-function)
  (cancel-timer nlinum-relative--timer)
  (setq nlinum-relative--timer nil)
  )

;;;###autoload
(defun nlinum-relative-toggle ()
  "Toggle between linum-relative and linum."
  (interactive)
  (if (eq nlinum-format-function nlinum-relative--format-function)
      (nlinum-relative-off)
    (nlinum-relative-on)))


;;;###autoload
(define-minor-mode nlinum-relative-mode
  "Display relative line numbers for current buffer."
  :group 'nlinum-relative
  (if nlinum-relative-mode
      (progn
        (nlinum-relative-on)
        (nlinum-mode 1))
    (nlinum-relative-off)
    (nlinum-mode -1)))

;;;###autoload
(define-globalized-minor-mode global-nlinum-relative-mode nlinum-relative-mode
  (lambda () (unless (minibufferp) (nlinum-relative-mode))))

;;;###autoload
(defun nlinum-relative-setup-evil ()
  "Setup nlinum-relative-mode for evil"
  (interactive)
  (add-hook 'evil-insert-state-entry-hook (lambda () (when (nlinum-relative-mode) (nlinum-relative-off))))
  (add-hook 'evil-insert-state-exit-hook (lambda () (when (nlinum-relative-mode) (nlinum-relative-on))))
  )

(provide 'nlinum-relative)
;;; nlinum-relative.el ends here
