;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!


;; system-type is a variable defined in `C source code'.
;; Its value is darwin

;; Documentation:
;; Value is symbol indicating type of operating system you are using.
;; Special values:
;;   `gnu'         compiled for a GNU Hurd system.
;;   `gnu/linux'   compiled for a GNU/Linux system.
;;   `darwin'      compiled for Darwin (GNU-Darwin, Mac OS X, ...).
;;   `ms-dos'      compiled as an MS-DOS application.
;;   `windows-nt'  compiled as a native W32 application.
;;   `cygwin'      compiled using the Cygwin library.
;; Anything else indicates some sort of Unix system.

(if (eq system-type 'windows-nt) ;; verifica se o sistema é Windows.
    ;; Se sim, usa a configuração específica para Windows.
    (progn
      ;; Configurações para Windows
      (setq doom-font (font-spec :family "CaskaydiaCove NF" :size 16 :weight 'semi-light)
            doom-variable-pitch-font (font-spec :family "CaskaydiaCove NF" :size 15)))
  ;; Se não for Windows, aplica as configurações padrão para Linux.
  (progn
    ;; Configurações para outros sistemas (Linux, macOS, etc.)
    (setq doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 16 :weight 'semi-light)
          doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size 15))))


;; (setq doom-theme 'doom-one)
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'frappe) ; or 'frappe 'latte, 'macchiato, or 'mocha
(setq catppuccin-flavor 'frappe) ; or 'frappe 'latte, 'macchiato, or 'mocha
(load-theme 'catppuccin t)
;; (require 'kaolin-themes)
;; (load-theme 'kaolin-valley-dark t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.

(setq user-full-name "Leonamsh"
      user-mail-address "lpdmonteiro@gmail.com")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; source: https://nayak.io/posts/golang-development-doom-emacs/
;; golang formatting set up
;; use gofumpt
(after! lsp-mode
  (setq  lsp-go-use-gofumpt t)
  )

;; enable all analyzers; not done by default
(after! lsp-mode
  (setq  lsp-go-analyses '((nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  )

(setq confirm-kill-emacs nil)        ;; Don't confirm on exit
;; (setq initial-buffer-choice 'eshell) ;; Eshell is initial buffer

;; Org base
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-modern-table-vertical 1)
(setq org-modern-table t)
(add-hook 'org-mode-hook #'hl-todo-mode)

;; Org Mode Enhancements
;; This sets the font size for each Org header level.  Having variable font sizes in an Org outline makes it visually appealing and more readable.

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Table of Contents for Org Mode
(use-package toc-org
    :commands toc-org-enable
    :init (add-hook 'org-mode-hook 'toc-org-enable))

(custom-theme-set-faces!
  ;; 'doom-one
  '(org-level-8 :inherit outline-3 :height 1.0)
  '(org-level-7 :inherit outline-3 :height 1.0)
  '(org-level-6 :inherit outline-3 :height 1.1)
  '(org-level-5 :inherit outline-3 :height 1.2)
  '(org-level-4 :inherit outline-3 :height 1.3)
  '(org-level-3 :inherit outline-3 :height 1.4)
  '(org-level-2 :inherit outline-2 :height 1.5)
  '(org-level-1 :inherit outline-1 :height 1.6)
  '(org-document-title  :height 1.8 :bold t :underline nil))

;; Markdown Mode
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(defun dt/toggle-markdown-view-mode ()
  ;; "Toggle between `markdown-mode' and `markdown-view-mode'."
  (interactive)
  (if (eq major-mode 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))

;; workaround the error
;; condition-case: Error in a Doom startup hook: doom-first-file-hook, global-git-commit-mode, (void-function transient--set-layout)

(let ((lfile (concat doom-local-dir "straight/repos/transient/lisp/transient.el")))
  (if (file-exists-p lfile)
      (load lfile)))

;; Copilot.el

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; Remove js2-mode from auto-mode-alist for .js files and replace it with js2-mode

(add-to-list 'major-mode-remap-alist '(js-mode . js2-mode))
(after! js2-mode
  (setq js2-basic-offset 2     
        js2-bounce-indent-p nil))

;; Prettier como formatador via Apheleia
(after! apheleia
  (setf (alist-get 'prettier apheleia-formatters)
        '("npx" "prettier" "--config" "~/.config/prettier/.prettierrc" "--stdin-filepath" filepath))
  (dolist (m '(js2-mode typescript-mode tsx-ts-mode json-mode))
    (setf (alist-get m apheleia-mode-alist) '(prettier))))

(add-hook 'js2-mode-hook #'apheleia-mode)  ;; formatar ao salvar nesse modo
;; ou globalmente:
;; (apheleia-global-mode +1)

;; Já que você usa js2-mode, silencie o aviso de ponto-e-vírgula se quiser:
(after! js2-mode
  (setq js2-strict-missing-semi-warning nil))

;; LSP continua com Eglot:
(setq eglot-format-on-save nil) ; deixa a formatação pro Prettier
