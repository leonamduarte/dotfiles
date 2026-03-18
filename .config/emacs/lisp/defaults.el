;;; defaults.el --- Global defaults -*- lexical-binding: t; -*-

(setq confirm-kill-emacs nil
      use-dialog-box nil
      use-file-dialog nil
      auto-insert-query nil
      require-final-newline t
      auto-insert-directory (expand-file-name "templates/" user-emacs-directory))

(setq user-full-name "bashln"
      user-mail-address "lpdmonteiro+doom@gmail.com")

(delete-selection-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(show-paren-mode 1)
(global-subword-mode 1)
(auto-insert-mode 1)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(provide 'defaults)
;;; defaults.el ends here
