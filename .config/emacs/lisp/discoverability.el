;;; discoverability.el --- Key discovery and leader map -*- lexical-binding: t; -*-

(use-package which-key
  :demand t
  :init
  (setq which-key-idle-delay 0.6
        which-key-idle-secondary-delay 0.05
        which-key-separator " -> "
        which-key-max-description-length 28
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.25
        which-key-sort-order 'which-key-key-order-alpha)
  :config
  (which-key-setup-side-window-bottom)
  (which-key-mode 1))

(define-prefix-command 'leo/leader-map)
(global-set-key (kbd "C-c m") #'leo/leader-map)

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC") #'leo/leader-map)
  (define-key evil-visual-state-map (kbd "SPC") #'leo/leader-map)
  (define-key evil-motion-state-map (kbd "SPC") #'leo/leader-map))

(define-key leo/leader-map (kbd ".") #'find-file)
(define-key leo/leader-map (kbd "SPC") #'execute-extended-command)

(define-prefix-command 'leo/leader-files-map)
(define-key leo/leader-map (kbd "f") 'leo/leader-files-map)
(define-key leo/leader-files-map (kbd "f") #'find-file)
(define-key leo/leader-files-map (kbd "r") #'consult-recent-file)
(define-key leo/leader-files-map (kbd "s") #'save-buffer)
(define-key leo/leader-files-map (kbd "d") #'dired)
(define-key leo/leader-files-map (kbd "p") #'project-find-file)

(define-prefix-command 'leo/leader-buffers-map)
(define-key leo/leader-map (kbd "b") 'leo/leader-buffers-map)
(define-key leo/leader-buffers-map (kbd "b") #'consult-buffer)
(define-key leo/leader-buffers-map (kbd "k") #'kill-current-buffer)
(define-key leo/leader-buffers-map (kbd "n") #'next-buffer)
(define-key leo/leader-buffers-map (kbd "p") #'previous-buffer)
(define-key leo/leader-buffers-map (kbd "i") #'ibuffer)

(define-prefix-command 'leo/leader-windows-map)
(define-key leo/leader-map (kbd "w") 'leo/leader-windows-map)
(define-key leo/leader-windows-map (kbd "v") #'split-window-right)
(define-key leo/leader-windows-map (kbd "s") #'split-window-below)
(define-key leo/leader-windows-map (kbd "d") #'delete-window)
(define-key leo/leader-windows-map (kbd "o") #'delete-other-windows)
(define-key leo/leader-windows-map (kbd "w") #'other-window)

(define-prefix-command 'leo/leader-project-map)
(define-key leo/leader-map (kbd "p") 'leo/leader-project-map)
(define-key leo/leader-project-map (kbd "s") #'project-switch-project)
(define-key leo/leader-project-map (kbd "f") #'project-find-file)
(define-key leo/leader-project-map (kbd "b") #'project-switch-to-buffer)
(define-key leo/leader-project-map (kbd "d") #'leo/project-root-dired)

(define-prefix-command 'leo/leader-git-map)
(define-key leo/leader-map (kbd "g") 'leo/leader-git-map)
(define-key leo/leader-git-map (kbd "g") #'magit-status)
(define-key leo/leader-git-map (kbd "b") #'magit-blame-addition)

(define-prefix-command 'leo/leader-code-map)
(define-key leo/leader-map (kbd "c") 'leo/leader-code-map)
(define-key leo/leader-code-map (kbd "d") #'xref-find-definitions)
(define-key leo/leader-code-map (kbd "r") #'xref-find-references)
(define-key leo/leader-code-map (kbd "a") #'eglot-code-actions)
(define-key leo/leader-code-map (kbd "n") #'eglot-rename)
(define-key leo/leader-code-map (kbd "b") #'flymake-show-buffer-diagnostics)
(define-key leo/leader-code-map (kbd "p") #'flymake-show-project-diagnostics)
(define-key leo/leader-code-map (kbd "f") #'apheleia-format-buffer)

(define-prefix-command 'leo/leader-open-map)
(define-key leo/leader-map (kbd "o") 'leo/leader-open-map)
(define-key leo/leader-open-map (kbd "a") #'org-agenda)
(define-key leo/leader-open-map (kbd "c") #'org-capture)
(define-key leo/leader-open-map (kbd "d") #'leo/open-dashboard)
(define-key leo/leader-open-map (kbd "e") #'eshell)
(define-key leo/leader-open-map (kbd "t") #'vterm)
(define-key leo/leader-open-map (kbd "f") #'dired)
(define-key leo/leader-open-map (kbd "n") #'neotree-toggle)
(define-key leo/leader-open-map (kbd "s") #'leo/open-scratch-buffer)
(define-key leo/leader-open-map (kbd "T") #'org-babel-tangle)

(define-prefix-command 'leo/leader-help-map)
(define-key leo/leader-map (kbd "h") 'leo/leader-help-map)
(define-key leo/leader-help-map (kbd "f") #'describe-function)
(define-key leo/leader-help-map (kbd "v") #'describe-variable)
(define-key leo/leader-help-map (kbd "k") #'describe-key)
(define-key leo/leader-help-map (kbd "m") #'describe-mode)
(define-key leo/leader-help-map (kbd "t") #'leo/load-theme)
(define-key leo/leader-help-map (kbd "r") #'leo/reload-config)
(define-key leo/leader-help-map (kbd "R") #'leo/restart-emacs)

(define-prefix-command 'leo/leader-dired-map)
(define-key leo/leader-map (kbd "d") 'leo/leader-dired-map)
(define-key leo/leader-dired-map (kbd "d") #'dired)
(define-key leo/leader-dired-map (kbd "j") #'dired-jump)
(define-key leo/leader-dired-map (kbd "p") #'leo/project-root-dired)

(define-prefix-command 'leo/leader-toggle-map)
(define-key leo/leader-map (kbd "t") 'leo/leader-toggle-map)
(define-key leo/leader-toggle-map (kbd "l") #'display-line-numbers-mode)
(define-key leo/leader-toggle-map (kbd "v") #'visual-line-mode)
(define-key leo/leader-toggle-map (kbd "h") #'hl-line-mode)
(define-key leo/leader-toggle-map (kbd "t") #'leo/load-theme)
(define-key leo/leader-toggle-map (kbd "x") #'leo/toggle-truncate-lines)

(define-prefix-command 'leo/leader-search-map)
(define-key leo/leader-map (kbd "s") 'leo/leader-search-map)
(define-key leo/leader-search-map (kbd "f") #'consult-fd)
(define-key leo/leader-search-map (kbd "l") #'consult-line)
(define-key leo/leader-search-map (kbd "g") #'consult-ripgrep)
(define-key leo/leader-search-map (kbd "i") #'consult-imenu)

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "SPC" "leader"
    "C-c m" "leader"
    "SPC ." "find file"
    "SPC f" "files"
    "SPC b" "buffers"
    "SPC w" "windows"
    "SPC p" "project"
    "SPC g" "git"
    "SPC c" "code"
    "SPC o" "open"
    "SPC h" "help"
    "SPC d" "dired"
    "SPC t" "toggles"
    "SPC s" "search")
  (which-key-add-keymap-based-replacements
    leo/leader-map
    "." "find file"
    "f" "files"
    "b" "buffers"
    "w" "windows"
    "p" "project"
    "g" "git"
    "c" "code"
    "o" "open"
    "h" "help"
    "d" "dired"
    "t" "toggles"
    "s" "search")
  (which-key-add-keymap-based-replacements
    leo/leader-help-map
    "f" "describe function"
    "v" "describe variable"
    "k" "describe key"
    "m" "describe mode"
    "t" "theme switch"
    "r" "reload config"
    "R" "restart emacs")
  (which-key-add-keymap-based-replacements
    leo/leader-code-map
    "d" "definitions"
    "r" "references"
    "a" "code actions"
    "n" "rename"
    "b" "buffer diagnostics"
    "p" "project diagnostics"
    "f" "format buffer")
  (which-key-add-keymap-based-replacements
    leo/leader-open-map
    "a" "org agenda"
    "c" "org capture"
    "d" "dashboard"
    "e" "eshell"
    "f" "dired"
    "n" "neotree toggle"
    "s" "scratch"
    "t" "terminal"
    "T" "org tangle")
  (which-key-add-keymap-based-replacements
    leo/leader-search-map
    "f" "find files"
    "l" "current buffer"
    "g" "ripgrep"
    "i" "imenu"))

(provide 'discoverability)
;;; discoverability.el ends here
