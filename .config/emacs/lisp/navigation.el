;;; navigation.el --- Dired ergonomics -*- lexical-binding: t; -*-

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :init
  (put 'dired-find-alternate-file 'disabled nil)
  (setq dired-listing-switches "-alh"
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        dired-dwim-target t
        dired-auto-revert-buffer t
        delete-by-moving-to-trash t)
  :hook (dired-mode . dired-hide-details-mode)
  :config
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "h") #'dired-up-directory)
  (define-key dired-mode-map (kbd "l") #'dired-find-file)
  (define-key dired-mode-map (kbd "^")
              (lambda () (interactive)
                (find-alternate-file "..")))
  (define-key dired-mode-map (kbd "z") #'dired-hide-details-mode))

(provide 'navigation)
;;; navigation.el ends here
