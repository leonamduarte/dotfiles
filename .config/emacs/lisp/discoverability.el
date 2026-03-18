;;; discoverability.el --- Key discovery and leader map -*- lexical-binding: t; -*-

(use-package which-key
  :demand t
  :init
  (setq which-key-idle-delay 0.6
        which-key-idle-secondary-delay 0.05
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-separator " -> "
        which-key-max-description-length 28
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-location 'bottom
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-sort-order 'which-key-key-order-alpha)
  :config
  (which-key-setup-side-window-bottom)
  (add-hook 'which-key-init-buffer-hook
            (lambda ()
              (setq-local line-spacing 3)))
  (which-key-mode 1)
  ;; ESC fecha o which-key imediatamente
  (define-key which-key-mode-map (kbd "ESC") #'which-key-abort)
  (define-key which-key-mode-map (kbd "<escape>") #'which-key-abort))

(define-prefix-command 'leo/leader-map)
(global-set-key (kbd "C-c m") #'leo/leader-map)

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "SPC") #'leo/leader-map)
  (define-key evil-visual-state-map (kbd "SPC") #'leo/leader-map)
  (define-key evil-motion-state-map (kbd "SPC") #'leo/leader-map))

(define-key leo/leader-map (kbd ".") #'find-file)
(define-key leo/leader-map (kbd "SPC") #'execute-extended-command)
(define-prefix-command 'leo/leader-tabs-map)
(define-key leo/leader-map (kbd "TAB") 'leo/leader-tabs-map)
(define-key leo/leader-tabs-map (kbd "TAB") #'leo/workspace-toggle-tab-bar)
(define-key leo/leader-tabs-map (kbd ".") #'leo/workspace-switch-to)
(define-key leo/leader-tabs-map (kbd "`") #'leo/workspace-other)
(define-key leo/leader-tabs-map (kbd "[") #'leo/workspace-switch-left)
(define-key leo/leader-tabs-map (kbd "]") #'leo/workspace-switch-right)
(define-key leo/leader-tabs-map (kbd "0") #'leo/workspace-switch-to-final)
(define-key leo/leader-tabs-map (kbd "n") #'leo/workspace-new)
(define-key leo/leader-tabs-map (kbd "N") #'leo/workspace-new-named)
(define-key leo/leader-tabs-map (kbd "l") #'leo/workspace-load)
(define-key leo/leader-tabs-map (kbd "s") #'leo/workspace-save)
(define-key leo/leader-tabs-map (kbd "r") #'leo/workspace-rename)
(define-key leo/leader-tabs-map (kbd "R") #'leo/workspace-restore-last-session)
(define-key leo/leader-tabs-map (kbd "d") #'leo/workspace-kill)
(define-key leo/leader-tabs-map (kbd "D") #'leo/workspace-delete-saved)
(define-key leo/leader-tabs-map (kbd "x") #'leo/workspace-kill-session)
(define-key leo/leader-tabs-map (kbd "k") #'leo/workspace-kill)
(dotimes (i 9)
  (let ((n (1+ i)))
    (global-set-key
     (kbd (format "M-%d" n))
     (lambda () (interactive) (leo/workspace-switch-to n)))))
(global-set-key (kbd "M-0") #'leo/workspace-switch-to-final)
(dotimes (i 9)
  (let ((n (1+ i)))
    (define-key
      leo/leader-tabs-map
      (kbd (number-to-string n))
      (lambda () (interactive) (leo/workspace-switch-to n)))))

(define-prefix-command 'leo/leader-files-map)
(define-key leo/leader-map (kbd "f") 'leo/leader-files-map)
(define-key leo/leader-files-map (kbd "f") #'find-file)
(define-key leo/leader-files-map (kbd "r") #'consult-recent-file)
(define-key leo/leader-files-map (kbd "s") #'save-buffer)
(define-key leo/leader-files-map (kbd "d") #'dired)
(define-key leo/leader-files-map (kbd "c") #'leo/open-config-entry)
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

(define-prefix-command 'leo/leader-jump-map)
(define-key leo/leader-map (kbd "j") 'leo/leader-jump-map)
(define-key leo/leader-jump-map (kbd "t") #'harpoon-toggle-file)
(define-key leo/leader-jump-map (kbd "l") #'harpoon-toggle-quick-menu)
(define-key leo/leader-jump-map (kbd "1") #'harpoon-go-to-1)
(define-key leo/leader-jump-map (kbd "2") #'harpoon-go-to-2)
(define-key leo/leader-jump-map (kbd "3") #'harpoon-go-to-3)
(define-key leo/leader-jump-map (kbd "4") #'harpoon-go-to-4)

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
(define-key leo/leader-toggle-map (kbd "w") #'visual-line-mode)
(define-key leo/leader-toggle-map (kbd "h") #'hl-line-mode)
(define-key leo/leader-toggle-map (kbd "t") #'leo/load-theme)
(define-key leo/leader-toggle-map (kbd "v") #'leo/toggle-vterm)
(define-key leo/leader-toggle-map (kbd "x") #'leo/toggle-truncate-lines)

(define-prefix-command 'leo/leader-search-map)
(define-key leo/leader-map (kbd "s") 'leo/leader-search-map)
(define-key leo/leader-search-map (kbd "f") #'consult-fd)
(define-key leo/leader-search-map (kbd "z") #'consult-fd)
(define-key leo/leader-search-map (kbd "l") #'consult-line)
(define-key leo/leader-search-map (kbd "g") #'consult-ripgrep)
(define-key leo/leader-search-map (kbd "i") #'consult-imenu)

(define-prefix-command 'leo/leader-diagnostics-map)
(define-key leo/leader-map (kbd "x") 'leo/leader-diagnostics-map)
(define-key leo/leader-diagnostics-map (kbd "x") #'flymake-show-buffer-diagnostics)
(define-key leo/leader-diagnostics-map (kbd "X") #'flymake-show-project-diagnostics)

(with-eval-after-load 'which-key
  (unless (get 'leo/which-key-replacement-alist 'initial-value)
    (put 'leo/which-key-replacement-alist
         'initial-value
         (copy-tree which-key-replacement-alist)))
  (setq which-key-replacement-alist
        (copy-tree (get 'leo/which-key-replacement-alist 'initial-value)))
  (which-key-add-key-based-replacements
    "SPC" "<leader>"
    "C-c m" "<leader>")
  (which-key-add-keymap-based-replacements
    leo/leader-map
    "." "find file"
    "TAB" "workspace"
    "f" "+files"
    "b" "+buffers"
    "w" "+windows"
    "p" "+project"
    "g" "+git"
    "j" "+harpoon"
    "c" "+code"
    "o" "+open"
    "h" "+help"
    "d" "+dired"
    "t" "+toggles"
    "s" "+Search"
    "x" "+diagnostics")
  (which-key-add-keymap-based-replacements
    leo/leader-jump-map
    "t" "toggle"
    "l" "list"
    "1" "goto 1"
    "2" "goto 2"
    "3" "goto 3"
    "4" "goto 4")
  (which-key-add-keymap-based-replacements
    leo/leader-tabs-map
    "TAB" "display tab bar"
    "." "switch"
    "`" "last"
    "[" "previous"
    "]" "next"
    "0" "final workspace"
    "1" "1st workspace"
    "2" "2nd workspace"
    "3" "3rd workspace"
    "4" "4th workspace"
    "5" "5th workspace"
    "6" "6th workspace"
    "7" "7th workspace"
    "8" "8th workspace"
    "9" "9th workspace"
    "n" "new"
    "N" "new named"
    "l" "load from file"
    "s" "save to file"
    "r" "rename"
    "R" "restore last"
    "d" "kill this"
    "D" "delete saved"
    "x" "kill session"
    "k" "kill this")
  (which-key-add-keymap-based-replacements
    leo/leader-files-map
    "f" "find file"
    "r" "recent"
    "s" "save"
    "d" "dired"
    "c" "config"
    "p" "project files")
  (which-key-add-keymap-based-replacements
    leo/leader-help-map
    "f" "function"
    "v" "variable"
    "k" "key"
    "m" "mode"
    "t" "theme"
    "r" "reload"
    "R" "restart")
  (which-key-add-keymap-based-replacements
    leo/leader-code-map
    "d" "definitions"
    "r" "references"
    "a" "actions"
    "n" "rename"
    "b" "buffer diag"
    "p" "project diag"
    "f" "format")
  (which-key-add-keymap-based-replacements
    leo/leader-open-map
    "a" "agenda"
    "c" "capture"
    "d" "dashboard"
    "e" "eshell"
    "f" "dired"
    "n" "neotree"
    "s" "scratch"
    "t" "terminal"
    "T" "tangle")
  (which-key-add-keymap-based-replacements
    leo/leader-toggle-map
    "l" "line nums"
    "w" "visual line"
    "h" "hl-line"
    "t" "theme"
    "v" "vterm"
    "x" "truncate")
  (which-key-add-keymap-based-replacements
    leo/leader-search-map
    "f" "find files"
    "z" "fd"
    "l" "line"
    "g" "ripgrep"
    "i" "imenu")
  (which-key-add-keymap-based-replacements
    leo/leader-diagnostics-map
    "x" "buffer diag"
    "X" "project diag"))

(provide 'discoverability)
;;; discoverability.el ends here
