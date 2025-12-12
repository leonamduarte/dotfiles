;;; init.el --- Configuração Base do Leonam -*- lexical-binding: t -*-
;;
;; Author: bashln <lpdmonteiro+doom@gmail.com>
;; Created: dezembro 12, 2025
;; Version: 0.3.0
;;
;;; Code:

;; ---------------------------------------------------------
;; 1. OTIMIZAÇÃO DE STARTUP & SISTEMA
;; ---------------------------------------------------------

;; Aumenta limite de GC (Garbage Collection) para o startup ser rápido
(setq gc-cons-threshold (* 50 1000 1000))

;; Hook: Depois que carregar, volta o GC para o normal (2MB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000)
                  gc-cons-percentage 0.1)))

;; Mantém o init.el limpo! Variáveis customizadas vão para custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; ---------------------------------------------------------
;; 2. GERENCIADOR DE PACOTES (MELPA)
;; ---------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package no-littering)
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; ---------------------------------------------------------
;; 3. EVIL MODE (VIM EMULATION)
;; ---------------------------------------------------------
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ---------------------------------------------------------
;; 4. INTERFACE E MENU (LEADER KEY - CORRIGIDO)
;; ---------------------------------------------------------
(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom)
  (setq which-key-side-window-max-width 0.33))

(use-package general
  :after evil
  :demand t
  :config
  (general-evil-setup t)

  ;; --- CORREÇÃO CRÍTICA DO SPC ---
  ;; Remove a função de scroll do SPC no modo motion (dashboard, dired, etc)
  (general-override-mode 1)
  (with-eval-after-load 'evil
    (define-key evil-motion-state-map (kbd "SPC") nil))

  ;; Cria o definer do Leader
  (general-create-definer leonam/leader-keys
    :states '(normal visual insert emacs motion) ;; 'motion' é essencial aqui
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  ;; Mapeamento Centralizado
  (leonam/leader-keys
   "."     '(find-file :which-key "Find file")
   "SPC"   '(execute-extended-command :which-key "M-x")
   
   ;; Buffer
   "b"     '(:ignore t :which-key "buffer")
   "bb"    '(switch-to-buffer :which-key "Switch buffer")
   "bk"    '(kill-current-buffer :which-key "Kill buffer")
   "bn"    '(next-buffer :which-key "Next buffer")
   "bp"    '(previous-buffer :which-key "Previous buffer")

   ;; File
   "f"     '(:ignore t :which-key "file")
   "ff"    '(find-file :which-key "Find file")
   "fs"    '(save-buffer :which-key "Save file")
   
   ;; Help
   "h"     '(:ignore t :which-key "help")
   "hr"    '((lambda () (interactive) (load-file user-init-file)) :which-key "Reload init.el")

   ;; Git
   "g"     '(:ignore t :which-key "git")
   "gg"    '(magit-status :which-key "Magit status")
   "gB"    '(magit-blame-addition :which-key "Magit blame")
   "gc"    '(magit-clone :which-key "Clone repo")
   "gi"    '(magit-init :which-key "Init repo")

   ;; Org
   "o"     '(:ignore t :which-key "org")
   "oa"    '(org-agenda :which-key "Agenda")
   "oc"    '(org-capture :which-key "Capture task")
   "oe"    '(org-export-dispatch :which-key "Export file")
   "ol"    '(org-store-link :which-key "Store link")
   "ot"    '(org-todo :which-key "Change TODO state")

   ;; Code
   "c"     '(:ignore t :which-key "code")
   "ca"    '(lsp-execute-code-action :which-key "Code action")
   "cd"    '(lsp-find-definition :which-key "Jump to definition")
   "cr"    '(lsp-rename :which-key "Rename variable")
   "cf"    '(apheleia-format-buffer :which-key "Format buffer")
   "cx"    '(lsp-java-organize-imports :which-key "Organize imports")))

;; ---------------------------------------------------------
;; 5. COMPLETION (BUSCA E HISTÓRICO)
;; ---------------------------------------------------------
(use-package vertico
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; ---------------------------------------------------------
;; 6. APARÊNCIA VISUAL (UI)
;; ---------------------------------------------------------
(use-package nerd-icons)

(ignore-errors
  (set-face-attribute 'default nil :family "BlexMono Nerd Font Medium" :height 140))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35)
  (setq doom-modeline-family "BlexMono Nerd Font Medium"))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; ---------------------------------------------------------
;; 7. GIT (MAGIT)
;; ---------------------------------------------------------
(use-package magit
  :commands (magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package hl-todo
  :hook ((prog-mode . hl-todo-mode)
         (org-mode . hl-todo-mode))
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#dc322f")
          ("FIXME"  . "#dc322f")
          ("DEBUG"  . "#b58900"))))

;; ---------------------------------------------------------
;; 8. ORG MODE (PRODUTIVIDADE)
;; ---------------------------------------------------------
(use-package org
  :hook (org-mode . org-indent-mode)
  :config
  (setq org-directory "~/org/"
        org-default-notes-file (expand-file-name "inbox.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-hide-emphasis-markers t)
  
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAIT(w)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)")))
  
  (setq org-todo-keyword-faces
        '(("IN-PROGRESS" . "orange") ("WAIT" . "gray") ("PROJ" . "purple"))))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◎")
        org-modern-block-name nil
        org-modern-keyword nil))

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode))

;; ---------------------------------------------------------
;; 9. IDE & CÓDIGO (LSP, TREESITTER, CORFU)
;; ---------------------------------------------------------
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-cycle t))

(use-package nerd-icons-corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-idle-delay 0.500
        lsp-log-io nil)
  :hook ((js-ts-mode . lsp)
         (typescript-ts-mode . lsp)
         (java-mode . lsp)
         (go-mode . lsp)
         (python-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t))

(use-package lsp-java
  :after lsp)

(use-package apheleia
  :config
  (apheleia-global-mode +1))

;; ---------------------------------------------------------
;; 10. AI (COPILOT)
;; ---------------------------------------------------------
(unless (package-installed-p 'copilot)
  (package-vc-install "https://github.com/copilot-emacs/copilot.el"))

(use-package copilot
  :ensure nil
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t))

;; ---------------------------------------------------------
;; 11. PROJECTILE (GERENCIAMENTO DE PROJETOS)
;; ---------------------------------------------------------
;; O Doom usa isso para saber que uma pasta é um projeto.
;; Necessário para a lista de projetos do Dashboard funcionar.
(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)) ;; Atalho padrão
  :config
  ;; Diga ao projectile onde você costuma guardar código para busca rápida
  (setq projectile-project-search-path '("~/development/" "~/projects/" "~/workspace/")))

;; Integração do Projectile com o menu Leader (Imitando o Doom SPC p)
(leonam/leader-keys
 "p"   '(:ignore t :which-key "project")
 "pp"  '(projectile-switch-project :which-key "Switch project")
 "pf"  '(projectile-find-file :which-key "Find file in project")
 "pr"  '(projectile-recentf :which-key "Recent project files"))

;; ---------------------------------------------------------
;; 12. DASHBOARD (TELA INICIAL)
;; ---------------------------------------------------------
(use-package dashboard
  :init
  ;; Define o dashboard como o buffer inicial
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (dashboard-setup-startup-hook)
  :config
  ;; Conteúdo Centralizado
  (setq dashboard-center-content t
        dashboard-vertically-center-content t)
  
  ;; Ícones (Usa o nerd-icons que já instalamos)
  (setq dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t)

  ;; O que mostrar na tela (na ordem)
  (setq dashboard-items '((recents   . 5)  ;; 5 Arquivos recentes
                          (projects  . 5)  ;; 5 Projetos recentes
                          (agenda    . 5)  ;; 5 Itens da agenda (se houver)
                          (bookmarks . 5))) ;; 5 Favoritos

  ;; Aparência (Logo e Títulos)
  (setq dashboard-startup-banner 'logo) ;; Use 'official, 'logo ou path para imagem png
  (setq dashboard-banner-logo-title "Bem-vindo ao Emacs do Leonam")
  
  ;; Rodapé (estilo Doom)
  (setq dashboard-footer-messages '("Keep it simple, stupid."
                                    "Doom is bloat, Vanilla is eternal."
                                    "Arch Linux: I use it btw."))
  (setq dashboard-footer-icon (nerd-icons-faicon "nf-fa-heart"
                                                 :height 1.2
                                                 :face 'dashboard-footer-icon-face)))

;; Garante que o dashboard funcione bem com o Evil (teclas j/k)
(use-package dashboard
  :after evil
  :config
  (evil-define-key 'motion dashboard-mode-map
    (kbd "r") 'dashboard-refresh-buffer
    (kbd "RET") 'dashboard-return
    (kbd "SPC") nil)) ;; Garante que o SPC não faça scroll aqui também

(provide 'init)
;;; init.el ends here
