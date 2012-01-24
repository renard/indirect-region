;;; indirect-region.el --- act like indirect-buffer but for region

;; Copyright © 2012 Sébastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org>

;; Author: Sébastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org>
;; Keywords: emacs, 
;; Created: 2012-01-24
;; Last changed: 2012-01-24 19:40:20
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/

;; This file is NOT part of GNU Emacs.

;;; Commentary:
;; 
;; Based on Mario Lang's indirect-region
;; http://www.emacswiki.org/emacs/IndirectBuffers#toc3
;;
;; To install:
;;   (require 'indirect-region)
;;   (define-key 'Control-X-prefix "r" 'indirect-region)
;;


;;; Code:

(defgroup indirect-region nil
  "`indirect-region' customization."
  :group 'convenience)


(defcustom indirect-region-hook nil
  "List of hook functions run by `indirect-region' after visiting source file."
  :type 'hook
  :group 'indirect-region)

;;;###autoload
(defun indirect-region (start end &optional arg)
  "Edit the current region in another buffer.

If called with `universal-argument', ask for a specific mode."
  (interactive "r\nP")
  (let ((buffer-name (generate-new-buffer-name
		      (format"*indirect %s*" (buffer-name))))
	(mode (if arg
		  (intern
		   (completing-read 
		    "Mode: "
		    (mapcar (lambda (e) 
			      (list (symbol-name e)))
			    (apropos-internal "-mode$" 'commandp))
		    nil t))
		major-mode)))
    (pop-to-buffer (make-indirect-buffer (current-buffer) buffer-name))
    (narrow-to-region start end)
    (funcall mode)
    (run-hooks 'indirect-region-hook)
    (goto-char (point-min))))



(provide 'indirect-region)
