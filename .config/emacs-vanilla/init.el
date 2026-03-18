;;; init.el --- Vanilla Emacs foundation -*- lexical-binding: t; -*-

;; Basic editor defaults only.
(setq inhibit-startup-message t
      initial-scratch-message nil
      ring-bell-function #'ignore
      use-short-answers t
      vc-follow-symlinks t
      create-lockfiles nil
      make-backup-files t
      version-control t
      backup-by-copying t
      load-prefer-newer t
      custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(setq-default indent-tabs-mode nil
              tab-width 2
              fill-column 80
              sentence-end-double-space nil)

(add-hook 'elpaca-after-init-hook
          (lambda ()
            (load custom-file 'noerror 'nomessage)
            (setq gc-cons-threshold (* 32 1024 1024))))

;; Elpaca bootstrap.
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))
;; use-package is built-in since Emacs 29
(require 'use-package)
(setq use-package-always-defer t
      use-package-always-ensure t)

;; Install use-package support.
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(elpaca transient)
(elpaca flymake)
(elpaca jsonrpc)
(elpaca project)
(elpaca track-changes)

(elpaca-wait)

(require 'defaults)

;; Layer 1: minimal modal editing foundation.
(use-package evil
 :ensure t :demand t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-respect-visual-line-mode t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :init
  (setq evil-collection-want-unimpaired-p nil)
  :config
  (evil-collection-init))

;; Layer 2A: minimal minibuffer completion.
(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode 1))

(use-package consult
  :commands (consult-buffer consult-line consult-ripgrep consult-imenu))

;; Layer 2B: minimal in-buffer completion and actions.
(use-package corfu
  :init
  (setq corfu-auto t
        corfu-auto-delay 0.15
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt
        corfu-quit-no-match 'separator)
  :config
  (global-corfu-mode 1))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Layer 3: minimal LSP foundation.
(use-package eglot
  :commands (eglot eglot-ensure)
  :hook ((js-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure))
  :init
  (setq eglot-autoshutdown t)
  :config
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode typescript-ts-mode)
                 "typescript-language-server" "--stdio")))

;; Layer 4: essential Git and terminal tools.
(use-package magit
  :commands (magit-status magit-dispatch))

(use-package vterm
  :commands (vterm)
  :init
  (setq vterm-shell (or (and (boundp 'explicit-shell-file-name)
                             explicit-shell-file-name)
                        shell-file-name)))

;; Layer 5: JS/TS tree-sitter refinement.
(when (require 'treesit nil t)
  (setq treesit-font-lock-level 4)
  (dolist (source '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
                    (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")))
    (add-to-list 'treesit-language-source-alist source t)))
(when (and (featurep 'treesit)
           (treesit-language-available-p 'javascript))
  (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode)))
(when (and (featurep 'treesit)
           (treesit-language-available-p 'typescript))
  (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode)))

;; Layer 6: minimal frontend formatting.
(use-package apheleia
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))
  (dolist (entry '(("\\.jsx?\\'" . prettier)
                   ("\\.tsx?\\'" . prettier)
                   ("\\.json\\'" . prettier)
                   ("\\.css\\'" . prettier)
                   ("\\.html?\\'" . prettier)))
    (add-to-list 'apheleia-mode-alist entry))
  (apheleia-global-mode 1))

;; Layer 7: minimal Copilot support.
(use-package copilot
  :ensure (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("C-c C-y" . copilot-accept-completion)))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'top))

;; Doom parity: editor, org, folding, VCS and small workflow extras.
(use-package yasnippet
  :hook (after-init . yas-global-mode))

(use-package vi-tilde-fringe
  :hook (after-init . global-vi-tilde-fringe-mode))

(use-package popper
  :hook (after-init . popper-mode)
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "\\*Warnings\\*"
          "\\*Help\\*"
          "\\*Compile-Log\\*"
          "\\*Flymake diagnostics\\*"
          help-mode
          helpful-mode
          compilation-mode
          eshell-mode
          vterm-mode
          org-roam-mode))
  (setq popper-display-control nil))

(use-package treemacs
  :commands (treemacs treemacs-select-window)
  :init
  (setq treemacs-width 32
        treemacs-follow-after-init t
        treemacs-filewatch-mode t
        treemacs-fringe-indicator-mode 'always))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package neotree
  :commands (neotree-toggle)
  :init
  (setq neo-smart-open t
        neo-window-width 32
        neo-theme 'arrow))

(use-package harpoon
  :ensure (:host github :repo "otavioschwanck/harpoon.el" :files ("*.el"))
  :commands (harpoon-add-file harpoon-toggle-file harpoon-toggle-quick-menu
                        harpoon-go-to-1 harpoon-go-to-2 harpoon-go-to-3 harpoon-go-to-4)
  :init
  (setq harpoon-separate-by-branch t))

(use-package diff-hl
  :hook (after-init . global-diff-hl-mode)
  :init
  (setq diff-hl-side 'right))

(use-package org
  :ensure nil
  :init
  (setq org-directory (expand-file-name "org/" (or (getenv "HOME") "~"))
        org-default-notes-file (expand-file-name "inbox.org" org-directory)
        org-agenda-files (list org-directory)
        org-capture-templates
        '(("t" "Todo" entry
           (file org-default-notes-file)
           "* TODO %?\n%U\n%a"))
        org-ellipsis " ◉ "
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAIT(w)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)")))
  (make-directory org-directory t)
  :config
  (add-to-list 'org-modules 'org-habit))

(use-package org-download
  :after org
  :hook (org-mode . org-download-enable)
  :init
  (setq org-download-method 'directory
        org-download-image-dir (expand-file-name "images/" org-directory)))

(use-package org-journal
  :commands (org-journal-new-entry)
  :init
  (setq org-journal-dir (expand-file-name "journal/" org-directory)
        org-journal-date-format "%A, %d %B %Y")
  (make-directory (expand-file-name "journal/" org-directory) t))

(use-package org-roam
  :commands (org-roam-node-find org-roam-node-insert org-roam-buffer-toggle org-roam-capture)
  :custom
  (org-roam-directory (expand-file-name "roam/" org-directory))
  (org-roam-completion-everywhere t)
  :config
  (make-directory (expand-file-name "roam/" org-directory) t)
  (org-roam-db-autosync-mode))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :init
  (setq org-modern-table t
        org-modern-hide-stars t))

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :init
  (setq org-auto-tangle-default t))

(use-package kdl-mode
  :mode "\\.kdl\\'")

(use-package markdown-mode
  :mode "\\.md\\'"
  :init
  (setq markdown-command "pandoc")
  :bind (:map markdown-mode-map
              ("zj" . markdown-next-visible-heading)
              ("zk" . markdown-previous-visible-heading)
              ("z;" . markdown-cycle)
              ("zi" . markdown-cycle-global)))

(use-package gcmh
  :hook (after-init . gcmh-mode)
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024)))

(use-package hideshow
  :ensure nil
  :hook (prog-mode . hs-minor-mode))

(when (fboundp 'tab-bar-mode)
  (tab-bar-mode 1)
  (tab-bar-history-mode 1)
  (setq tab-bar-show 1))

(defun leo/move-line-up ()
  "Move the current line up by one."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun leo/move-line-down ()
  "Move the current line down by one."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun leo/move-text-up ()
  "Move region up, or current line up if no region is active."
  (interactive)
  (if (use-region-p)
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (delete-and-extract-region beg end)))
        (goto-char beg)
        (forward-line -1)
        (let ((new-beg (point)))
          (insert text)
          (set-mark new-beg)
          (goto-char (+ new-beg (length text)))
          (setq deactivate-mark nil)))
    (leo/move-line-up)))

(defun leo/move-text-down ()
  "Move region down, or current line down if no region is active."
  (interactive)
  (if (use-region-p)
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (delete-and-extract-region beg end)))
        (goto-char beg)
        (forward-line 1)
        (let ((new-beg (point)))
          (insert text)
          (set-mark new-beg)
          (goto-char (+ new-beg (length text)))
          (setq deactivate-mark nil)))
    (leo/move-line-down)))

(global-set-key (kbd "M-j") #'leo/move-text-down)
(global-set-key (kbd "M-k") #'leo/move-text-up)
(global-set-key (kbd "C-x b") #'consult-buffer)
(global-set-key (kbd "C-c s l") #'consult-line)
(global-set-key (kbd "C-c s f") #'consult-fd)
(global-set-key (kbd "C-c s g") #'consult-ripgrep)
(global-set-key (kbd "C-c r") #'consult-recent-file)
(global-set-key (kbd "C-c i") #'consult-imenu)
(global-set-key (kbd "C-c g") #'magit-status)
(global-set-key (kbd "C-c t") #'vterm)
(global-set-key (kbd "C-c e") #'eshell)

(with-eval-after-load 'evil
  (setq evil-kill-on-visual-paste nil)
  (defun leo/evil-black-hole-delete-char ()
    "Delete forward without touching the default register."
    (interactive)
    (delete-char 1))
  (defun leo/evil-visual-shift-left ()
    "Shift the active visual selection left and restore it."
    (interactive)
    (evil-shift-left (region-beginning) (region-end))
    (evil-normal-state)
    (evil-visual-restore))
  (defun leo/evil-visual-shift-right ()
    "Shift the active visual selection right and restore it."
    (interactive)
    (evil-shift-right (region-beginning) (region-end))
    (evil-normal-state)
    (evil-visual-restore))
  (evil-define-key 'normal 'global (kbd "x") #'leo/evil-black-hole-delete-char)
  (evil-define-key 'visual 'global (kbd "<") #'leo/evil-visual-shift-left)
  (evil-define-key 'visual 'global (kbd ">") #'leo/evil-visual-shift-right))

(defun leo/flymake-buffer-diagnostics ()
  "Show diagnostics for the current buffer."
  (interactive)
  (flymake-show-buffer-diagnostics))

(defun leo/flymake-project-diagnostics ()
  "Show diagnostics for the current project."
  (interactive)
  (flymake-show-project-diagnostics))

(add-to-list 'display-buffer-alist
             '("\\*Flymake diagnostics\\*"
               display-buffer-in-side-window
               (side . bottom)
               (slot . 0)
               (window-height . 0.25)))

(global-set-key (kbd "C-c d b") #'leo/flymake-buffer-diagnostics)
(global-set-key (kbd "C-c d p") #'leo/flymake-project-diagnostics)
(global-set-key (kbd "C-c d r") #'eglot-rename)
(global-set-key (kbd "C-c d a") #'eglot-code-actions)

(global-set-key (kbd "C-c o t") #'org-babel-tangle)
(global-set-key (kbd "C-c o c") #'org-capture)
(global-set-key (kbd "C-c o a") #'org-agenda)

;; File templates and snippet parity without a Doom layer.
(require 'discoverability)
(require 'navigation)
(require 'startup)
(require 'ui)

;;; init.el ends here
