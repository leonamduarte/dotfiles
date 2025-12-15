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

;; --- CORREÇÃO DE DIRETÓRIO (WINDOWS) ---
;; Força o Emacs a usar a pasta de usuário como diretório padrão
;; ao invés da pasta de instalação (System32 ou Program Files).
(setq default-directory "~/")
(cd "~/")

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
;; 4. INTERFACE E MENU (LEADER KEY)
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
  
  ;; Correção Definitiva do SPC (Override + Unbind)
  (general-override-mode 1)
  (with-eval-after-load 'evil
    (define-key evil-motion-state-map (kbd "SPC") nil))
  
  ;; Carrega o arquivo externo de atalhos
  ;; Certifique-se que o keybindings.el está na mesma pasta do init.el
  (load (expand-file-name "keybindings.el" user-emacs-directory)))

(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer) ;; Opcional: substitui o switch-buffer normal
         ;; Outros bindings do consult...
         ))

(defun leonam/abrir-arquivo-recente ()
  "Usa o completing-read (e o Vertico) para escolher um arquivo recente."
  (interactive)
  ;; Garante que o modo recentf está ativo para a lista não estar vazia
  (recentf-mode 1)
  (let ((arquivo (completing-read "Recentes: " recentf-list)))
    (find-file arquivo)))


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
  (set-face-attribute 'default nil :family "AdwaitaMono Nerd Font" :height 130))

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

;; --- 1. TREESITTER (Syntax Highlighting Inteligente) ---
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  ;; Isso aqui já faz o trabalho de instalar gramáticas e
  ;; fazer o "remap" de js-mode para js-ts-mode automaticamente
  (global-treesit-auto-mode))

;; --- 2. AUTO-COMPLETE (Corfu) ---
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t))

(use-package nerd-icons-corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; --- 3. LSP MODE (O Cérebro) ---

(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js-jsx-mode)) ;; Suporte a React/JSX
  :config
  ;; Desliga os avisos nativos do js2 (deixa o LSP cuidar disso)
  ;; para não ficar com "sujeira" duplicada na tela.
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-idle-delay 0.500
        lsp-log-io nil)
  ;; Otimizações de performance para LSP
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  
  :hook (
         ;; Ativa o LSP automaticamente para os modos baseados em Treesitter
         (js2-mode . lsp)
         (js2-jsx-mode . lsp)
         (typescript-ts-mode . lsp)
         (json-mode . lsp)
         ;; Outras linguagens
         (java-mode . lsp)
         (go-mode . lsp)
         (python-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t))

;; Necessário para seu Java funcionar bem
(use-package lsp-java
  :after lsp)

;; --- 4. FORMATTER (Apheleia) ---
;; O Apheleia formata o código ao salvar sem travar o editor
(use-package apheleia
  :config
  (apheleia-global-mode +1))

;; Garantia extra: Forçar o uso do js-ts-mode caso o treesit-auto falhe em algo
;; (O treesit-auto geralmente faz isso sozinho, mas não faz mal deixar aqui)
;; (add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))
;; (add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))

;; NOTA: Removi as linhas do Eglot e o hook de formatação do Eglot.
;; O 'lsp-mode' já formata e o 'apheleia' cuida disso também.

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

;; ---------------------------------------------------------
;; 13. SISTEMA (RESTART)
;; ---------------------------------------------------------
(use-package restart-emacs
  :commands (restart-emacs) ;; Carregamento preguiçoso (só carrega quando chamar o comando)
  :config
  ;; 1. Tenta reabrir o Emacs com as mesmas janelas e posições de antes
  ;; (Muito útil no Windows para não perder o layout)
  (setq restart-emacs-restore-frames t)

  ;; 2. Garante que ele use o binário correto no Windows
  (when (eq system-type 'windows-nt)
    (setq restart-emacs-binary-path (expand-file-name "bin/runemacs.exe" invocation-directory))))

(provide 'init)
;;; init.el ends here
