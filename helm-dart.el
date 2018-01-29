;;; helm-dart.el --- Helm interface for dart -*- lexical-binding: t; -*-

;; Author: Sidart Kurias
;; URL: https://github.com/sid-kurias/dart-mode
;; Version: 0.1
;; Package-Requires: ((helm) (dart-mode "0.20"))
;; Keywords: language, dart

;; Copyright (C) 2017 Sidart Kurias.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Helm completion for quick fixes in dart.
;;; Merged in changes provided by https://github.com/averrin
;; Known bugs:
;;

;;; Code:
(require 'helm)

(defun helm-dart-quick-fix()
  "Use helm to complete quick fixes."
  (interactive)
  (dart-quick-fix 'helm--dart-qf))

(defun helm--dart-qf (fixlist edit-cb)
  "Callback for dart quick fixes specific to helm.
Argument FIXLIST The list of possible fixes returned by analysis server.
Argument EDIT-CB The callback to be invoked once a fix is selected by the user."
  (let ((messages (mapcar (lambda (x) (cdr (assoc 'message x))) fixlist)))
    (helm
     :sources (helm-build-sync-source "Apply quick fix"
		:candidates  messages
		:action  (lambda (msg)
			   (let* ((index (cl-position msg messages :test 'equal))
				  (editslist (cdr (assoc 'edits (aref fixlist index))))
				  (edit (cdr (aref editslist 0)))
				  (edit (aref (cdr (assoc 'edits edit)) 0)))
			     (funcall edit-cb edit))))
     :buffer "*dart-quick-fixes*")))

(provide 'helm-dart)

;;; helm-dart.el ends here
