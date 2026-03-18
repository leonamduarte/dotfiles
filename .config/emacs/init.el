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

(let* ((bash (or (executable-find "bash") shell-file-name))
       (fish (or (executable-find "fish") bash)))
  (setq shell-file-name bash
        explicit-shell-file-name fish))

(let ((go-bin (expand-file-name "go/bin" (or (getenv "HOME") "~"))))
  (when (file-directory-p go-bin)
    (add-to-list 'exec-path go-bin)
    (setenv "PATH" (concat go-bin path-separator (getenv "PATH")))))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(make-directory (expand-file-name "backups/" user-emacs-directory) t)
(make-directory (expand-file-name "auto-save/" user-emacs-directory) t)

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(setq-default indent-tabs-mode nil
              tab-width 2
              fill-column 80
              sentence-end-double-space nil)

(add-hook 'elpaca-after-init-hook
          (lambda ()
            (load custom-file 'noerror 'nomessage)))

(defun leo/enable-apheleia-mode (pattern formatter executable)
  "Enable FORMATTER for files matching PATTERN when EXECUTABLE exists."
  (when (executable-find executable)
    (add-to-list 'apheleia-mode-alist (cons pattern formatter))))

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
(elpaca emmet-mode)
(elpaca graphql-mode)
(elpaca haml-mode)
(elpaca markdown-mode)
(elpaca pip-requirements)
(elpaca pug-mode)
(elpaca rainbow-mode)
(elpaca sass-mode)
(elpaca doom-modeline)
(elpaca doom-themes)
(elpaca (slim-mode :host github
                    :repo "slim-template/emacs-slim"
                    :files ("slim-mode.el")))
(elpaca treesit-auto)
(elpaca go-mode)
(elpaca json-mode)
(elpaca kotlin-mode)
(elpaca lua-mode)
(elpaca typescript-mode)
(elpaca web-mode)
(elpaca yaml-mode)

(elpaca-wait)

(require 'defaults)

;; Layer 1: minimal modal editing foundation.
(use-package evil
  :demand t
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
        corfu-quit-no-match 'separator
        corfu-popupinfo-delay 0.5
        corfu-popupinfo-max-height 6)
  :hook (after-init . global-corfu-mode)
  :config
  (corfu-popupinfo-mode 1)
  (define-key corfu-map (kbd "TAB") #'corfu-next)
  (define-key corfu-map (kbd "<tab>") #'corfu-next)
  (define-key corfu-map (kbd "S-TAB") #'corfu-previous)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous))

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
  :hook ((js-ts-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (go-ts-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (web-mode . eglot-ensure))
  :init
  (setq eglot-autoshutdown t)
  :config
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode typescript-ts-mode)
                 "typescript-language-server" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((web-mode) "typescript-language-server" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((json-mode json-ts-mode) "vscode-json-language-server" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((yaml-mode yaml-ts-mode) "yaml-language-server" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) "pyright-langserver" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) "gopls"))
  (add-to-list 'eglot-server-programs
               '((lua-mode lua-ts-mode) "lua-language-server"))
  (add-to-list 'eglot-server-programs
               '((kotlin-mode) "kotlin-language-server")))

(use-package eldoc
  :ensure nil
  :init
  (setq eldoc-echo-area-use-multiline-p nil
        eldoc-display-functions '(eldoc-display-in-echo-area)))

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
(use-package treesit-auto
  :ensure nil
  :if (fboundp 'treesit-available-p)
  :init
  (setq treesit-auto-install nil)
  :hook (after-init . global-treesit-auto-mode))

(when (require 'treesit nil t)
  (setq treesit-font-lock-level 4)
  (dolist (source '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
                    (json "https://github.com/tree-sitter/tree-sitter-json")
                    (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
                    (go "https://github.com/tree-sitter/tree-sitter-go" "master" "src")
                    (python "https://github.com/tree-sitter/tree-sitter-python" "master" "src")
                    (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
                    (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
                    (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
    (add-to-list 'treesit-language-source-alist source t))
  (when (treesit-language-available-p 'javascript)
    (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode)))
  (when (treesit-language-available-p 'json)
    (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode)))
  (when (treesit-language-available-p 'go)
    (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode)))
  (when (treesit-language-available-p 'python)
    (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))
  (when (treesit-language-available-p 'yaml)
    (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode)))
  (when (treesit-language-available-p 'typescript)
    (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))))

;; Layer 6: minimal frontend formatting.
(use-package apheleia
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))
  (setf (alist-get 'black apheleia-formatters)
        '("black" "-q" "-"))
  (setf (alist-get 'gofmt apheleia-formatters)
        '("gofmt"))
  (setf (alist-get 'stylua apheleia-formatters)
        '("stylua" "--search-parent-directories" "--stdin-filepath" filepath "-"))
  (dolist (pattern '("\\.jsx?\\'" "\\.tsx?\\'" "\\.json\\'" "\\.ya?ml\\'" "\\.css\\'" "\\.html?\\'"))
    (leo/enable-apheleia-mode pattern 'prettier "prettier"))
  (leo/enable-apheleia-mode "\\.py\\'" 'black "black")
  (leo/enable-apheleia-mode "\\.go\\'" 'gofmt "gofmt")
  (leo/enable-apheleia-mode "\\.lua\\'" 'stylua "stylua")
  :hook (after-init . apheleia-global-mode))

;; Layer 7: minimal Copilot support.
(use-package copilot
  :ensure (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :hook ((js-ts-mode . copilot-mode)
         (typescript-ts-mode . copilot-mode)
         (go-ts-mode . copilot-mode)
         (python-ts-mode . copilot-mode)
         (web-mode . copilot-mode))
  :bind (:map copilot-completion-map
              ("<backtab>" . copilot-accept-completion)
              ("C-c C-y" . copilot-accept-completion))
  :init
  (setq copilot-indent-offset-warning-disable t))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'bitmap
        highlight-indent-guides-responsive 'top))

(use-package emmet-mode
  :ensure nil
  :hook ((web-mode . emmet-mode)
         (css-mode . emmet-mode)))

(use-package rainbow-mode
  :ensure nil
  :hook ((css-mode . rainbow-mode)
         (web-mode . rainbow-mode)
         (json-mode . rainbow-mode)))

;; Doom parity: editor, org, folding, VCS and small workflow extras.
(use-package yasnippet
  :hook (after-init . yas-global-mode))

(use-package vi-tilde-fringe
  :hook (prog-mode . vi-tilde-fringe-mode)
  :hook (text-mode . vi-tilde-fringe-mode))

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
  :hook (prog-mode . diff-hl-mode)
  :hook (text-mode . diff-hl-mode)
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
        org-modern-star 'replace
        org-modern-hide-stars 'leading
        org-modern-list '((?+ . "◦")
                          (?- . "–")
                          (?* . "•"))))

(use-package typescript-mode
  :ensure nil
  :defer t
  :init
  (setq typescript-indent-level 2))

(use-package go-mode
  :ensure nil
  :mode "\\.go\\'")

(use-package json-mode
  :ensure nil
  :mode "\\.json\\'")

(use-package lua-mode
  :ensure nil
  :mode "\\.lua\\'"
  :init
  (setq lua-indent-level 2))

(use-package kotlin-mode
  :ensure nil
  :mode "\\.kt\\'")

(use-package web-mode
  :ensure nil
  :mode ("\\.tsx\\'" "\\.jsx\\'" "\\.html?\\'")
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

(use-package graphql-mode
  :ensure nil
  :mode ("\\.gql\\'" "\\.graphql\\'"))

(use-package haml-mode
  :ensure nil
  :mode "\\.haml\\'")

(use-package pip-requirements
  :ensure nil
  :mode "requirements[^/]*\\.txt\\'")

(use-package pug-mode
  :ensure nil
  :mode "\\.pug\\'")

(use-package sass-mode
  :ensure nil
  :mode "\\.s[ac]ss\\'")

(use-package slim-mode
  :ensure nil
  :mode "\\.slim\\'")

(use-package yaml-mode
  :ensure nil
  :mode "\\.ya?ml\\'"
  :init
  (setq yaml-indent-offset 2))

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :init
  (setq org-auto-tangle-default t))

(use-package kdl-mode
  :mode "\\.kdl\\'")

(use-package markdown-mode
  :ensure nil
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

(setq read-process-output-max (* 1024 1024)
      fast-but-imprecise-scrolling t)

(use-package hideshow
  :ensure nil
  :hook (prog-mode . hs-minor-mode))

(when (fboundp 'tab-bar-mode)
  (setq tab-bar-show nil
        tab-bar-close-button-show nil
        tab-bar-new-button-show nil
        tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))

(with-eval-after-load 'evil
  (setq evil-kill-on-visual-paste nil)
  (evil-define-key 'normal 'global (kbd "x") #'leo/evil-black-hole-delete-char)
  (evil-define-key 'visual 'global (kbd "<") #'leo/evil-visual-shift-left)
  (evil-define-key 'visual 'global (kbd ">") #'leo/evil-visual-shift-right))

;; ESC fecha janelas de ajuda e popups com um único pressionamento
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;; Mapeamentos específicos para modos comuns
(with-eval-after-load 'help-mode
  (define-key help-mode-map (kbd "ESC") #'quit-window))

(with-eval-after-load 'debugger-mode
  (define-key debugger-mode-map (kbd "ESC") #'debugger-quit))

(with-eval-after-load 'messages-buffer-mode
  (define-key messages-buffer-mode-map (kbd "ESC") #'quit-window))

(with-eval-after-load 'special-mode
  (define-key special-mode-map (kbd "ESC") #'quit-window))

(add-to-list 'display-buffer-alist
             '("\\*Flymake diagnostics\\*"
               display-buffer-in-side-window
               (side . bottom)
               (slot . 0)
               (window-height . 0.25)))

;; Load local modules.
(require 'utils)
(require 'discoverability)
(require 'navigation)
(require 'startup)
(require 'ui)

(when (fboundp 'tab-bar-mode)
  (add-hook 'tab-bar-tab-post-select-functions #'leo/workspace--remember-last)
  (add-hook 'kill-emacs-hook #'leo/workspace-save-last-session)
  (leo/workspace-ensure-main))

(global-set-key (kbd "M-j") #'leo/move-text-down)
(global-set-key (kbd "M-k") #'leo/move-text-up)

;;; init.el ends here
