;;; startup.el --- Startup and dashboard -*- lexical-binding: t; -*-

(defun leo/open-dashboard ()
  "Refresh and show the dashboard buffer."
  (interactive)
  (require 'dashboard)
  (dashboard-refresh-buffer)
  (switch-to-buffer "*dashboard*"))

(use-package dashboard
  :demand t
  :init
  (setq dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-set-heading-icons nil
        dashboard-set-file-icons nil
        dashboard-items '((recents . 8)
                          (projects . 5)
                          (bookmarks . 5))
        initial-buffer-choice #'leo/open-dashboard)
  :config
  (dashboard-setup-startup-hook))

(provide 'startup)
;;; startup.el ends here
