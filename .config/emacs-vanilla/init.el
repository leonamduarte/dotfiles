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

(setq-default indent-tabs-mode nil
              tab-width 4
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
    (when (<= emacs-major-version 28)
      (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process
                                 `("git" nil ,buffer t "clone"
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
            (progn
              (message "%s" (buffer-string))
              (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error)
       (warn "%s" err)
       (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil))
      (load "./elpaca-autoloads"))))

(add-hook 'after-init-hook #'elpaca-process-queues)

;; Install use-package support and enable Elpaca integration.
(elpaca use-package
  (setq use-package-always-defer t
        use-package-always-ensure t))

(elpaca elpaca-use-package
  (require 'elpaca-use-package)
  (elpaca-use-package-mode))

(elpaca-wait)
(require 'use-package)

;; Layer 1: minimal modal editing foundation.
(use-package evil
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
  :ensure t
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
  (setq vterm-shell (or explicit-shell-file-name shell-file-name)))

;; Layer 5: JS/TS tree-sitter refinement.
(when (treesit-available-p)
  (setq treesit-font-lock-level 4)
  (dolist (source '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
                    (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")))
    (add-to-list 'treesit-language-source-alist source t)))
(when (and (treesit-available-p)
           (treesit-ready-p 'javascript))
  (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode)))
(when (and (treesit-available-p)
           (treesit-ready-p 'typescript))
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

;; Layer 8: minimal file navigation with built-in Dired.
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
  (define-key dired-mode-map (kbd "^")
              (lambda () (interactive)
                (find-alternate-file ".."))))

;; Layer 9: light UI polish.
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-icon nil
        doom-modeline-height 24
        doom-modeline-bar-width 3))

;;; init.el ends here
