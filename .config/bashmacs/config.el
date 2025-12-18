;;; config.el --- M  dulos e Plugins do Bashln -*- lexical-binding: t; coding: utf-8 -*-

;;; Commentary:
;;; Configura    es principais do Emacs.
;;; Code:

;; =========================================================
;; 1. BASE DO SISTEMA / STARTUP
;; =========================================================

;; Startup limpo e silencioso
(setq inhibit-startup-screen t
      initial-scratch-message nil
      echo-keystrokes 0.1
      confirm-kill-emacs nil
      even-window-sizes 'height-only
      window-combination-resize t
      help-window-select t)

;; y/n em vez de yes/no
(fset 'yes-or-no-p 'y-or-n-p)


;; ---------------------------------------------------------
;; Estado e histórico
;; ---------------------------------------------------------

(use-package no-littering
  :demand t
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))
        recentf-save-file
        (no-littering-expand-var-file-name "recentf")))

;; agora sim: recentf
(setq recentf-max-saved-items 200
      recentf-max-menu-items 50
      recentf-auto-cleanup 'never
      recentf-exclude
      '("/tmp/" "/ssh:" "/sudo:" "\\.git/" "COMMIT_EDITMSG"))

(recentf-mode 1)

;; garante carga no startup
(add-hook 'emacs-startup-hook #'recentf-load-list)

;; garante salvamento
(add-hook 'kill-emacs-hook #'recentf-save-list)

;; salvamento periódico (extra seguro)
(run-at-time nil (* 5 60) #'recentf-save-list)

;; ---------------------------------------------------------
;; Garbage Collector — rápido no startup, normal depois
;; ---------------------------------------------------------

(setq gc-cons-threshold (* 50 1000 1000)
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1000 1000)
                  gc-cons-percentage 0.1)))

;; =========================================================
;; 2. UX GLOBAL (CURSOR, SCROLL, LINHAS)
;; =========================================================

;; Cursor previsível (estilo IDE moderna)
(setq-default cursor-type 'bar)

(blink-cursor-mode -1)

;; Espaçamento sutil entre linhas (menos cansaço visual)
(setq-default line-spacing 0.12)

;; Scroll suave e controlado
(setq scroll-margin 5
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; Fringes discretas e simétricas
(set-fringe-mode 10)

;; ---------------------------------------------------------
;; Numeração de linhas
;; ---------------------------------------------------------

;; desligado globalmente
(global-display-line-numbers-mode -1)

;; ligado apenas em código
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(setq display-line-numbers-type 'relative)

;; ---------------------------------------------------------
;; Comportamentos de edição
;; ---------------------------------------------------------

;; pares automáticos: (), {}, "", etc
(electric-pair-mode 1)

;; indentação automática
(electric-indent-mode 1)

;; substitui seleção ao digitar
(delete-selection-mode 1)

;; destaca linha atual apenas em código
(add-hook 'prog-mode-hook #'hl-line-mode)

;; =========================================================
;; 3. EVIL + KEYBINDINGS
;; =========================================================

;; ---------------------------------------------------------
;; Evil (núcleo)
;; ---------------------------------------------------------

(use-package evil
  
  :demand t
  :init
  ;; essas variáveis PRECISAM estar antes do load
  (setq evil-want-integration t
        evil-want-keybinding nil   ;; obrigatório p/ evil-collection
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

;; ---------------------------------------------------------
;; Evil Collection (integração com modos nativos)
;; ---------------------------------------------------------

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ---------------------------------------------------------
;; Which-key (descoberta de atalhos)
;; ---------------------------------------------------------

(use-package which-key
  
  :init
  (which-key-mode 1)
  :config
  (setq which-key-idle-delay 0.3
        which-key-side-window-location 'bottom))

;; ---------------------------------------------------------
;; General.el (leader key estilo Doom)
;; ---------------------------------------------------------

(use-package general
  :after evil
  :config
  ;; habilita integração com Evil
  (general-evil-setup t)

  ;; override global (Doom-like)
  (general-override-mode 1)

  ;; definer do leader
  (general-create-definer bashln/leader-keys
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC")

  ;; MUITO IMPORTANTE:
  ;; remove SPC do motion map para não vazar no insert
  (define-key evil-motion-state-map (kbd "SPC") nil)

  ;; carrega os atalhos separados
  (load (expand-file-name "keybindings.el" user-emacs-directory)))

;; =========================================================
;; 4. UI / VISUAL
;; =========================================================

;; ---------------------------------------------------------
;; Chrome do Emacs (IDE, não navegador)
;; ---------------------------------------------------------

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; ---------------------------------------------------------
;; Fonte
;; ---------------------------------------------------------

(ignore-errors
  
  (defun leo/set-font-with-fallback (families height)
    (catch 'font-found
      (dolist (family families)
	(when (member family (font-family-list))
          (set-face-attribute 'default nil
                              :family family
                              :height height
                              :weight 'regular)
          (message "Fonte aplicada: %s" family)
          (throw 'font-found t)))
      (message "Nenhuma fonte encontrada: %s" families)))

  (leo/set-font-with-fallback
   '(
     "JetBrainsMono Nerd Font"
     "JetBrainsMono NF"
     "Iosevka NF"
     "Iosevka Nerd Font"
     "FiraCode Nerd Font"
     )
   120)

  (setq-default line-spacing 0.1)
  (setq doom-themes-enable-italic nil))

;; ---------------------------------------------------------
;; Tema
;; ---------------------------------------------------------

(use-package doom-themes
  
  :config
  ;; Doom-like de verdade
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)

  (load-theme 'doom-one t))

;; ---------------------------------------------------------
;; Ícones
;; ---------------------------------------------------------

(use-package nerd-icons
  )

;; ---------------------------------------------------------
;; Modeline
;; ---------------------------------------------------------

(use-package doom-modeline
  
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 28
                        doom-modeline-minor-modes nil
                        doom-modeline-enable-word-count nil
                        doom-modeline-buffer-file-name-style
                        'truncate-upto-project))

;; ---------------------------------------------------------
;; ESLint LSP
;; ---------------------------------------------------------

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-disabled-clients 'javascript-typescript-langserver)
  (add-to-list 'lsp-disabled-clients 'ts-ls)
  (add-to-list 'lsp-language-id-configuration '(js-ts-mode . "javascript"))
  (add-to-list 'lsp-language-id-configuration '(tsx-ts-mode . "typescriptreact"))
  (add-to-list 'lsp-language-id-configuration '(typescript-ts-mode . "typescript")))

(with-eval-after-load 'lsp-mode
  (setq lsp-eslint-auto-fix-on-save nil
        lsp-eslint-format-enable nil)
  )


;; =========================================================
;; 5. COMPLETION STACK (VERTICO)
;; =========================================================

;; ---------------------------------------------------------
;; Vertico (minibuffer moderno)
;; ---------------------------------------------------------

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t)
  (vertico-count 17)
  (vertico-resize nil)
  :config
  ;; multiform vem junto com vertico
  (require 'vertico-multiform)

  (vertico-multiform-mode 1)

  (setq vertico-multiform-commands
        '((execute-extended-command buffer)
	  (consult-buffer buffer)
          (consult-imenu buffer)
          (consult-ripgrep buffer)
          (consult-line buffer)
          ))
(setq display-buffer-alist
      '(("\\*Completions\\*"
         (display-buffer-in-side-window)
         (side . bottom)
         (slot . 0)
         (window-height . 0.3))

        ("\\*Help\\*"
         (display-buffer-in-side-window)
         (side . right)
         (slot . 1)
         (window-width . 0.4))))

  )


;; ---------------------------------------------------------
;; Orderless (matching poderoso, domado)
;; ---------------------------------------------------------

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles orderless partial-completion))))
  (orderless-component-separator
   #'orderless-escapable-split-on-space))

;; ---------------------------------------------------------
;; Consult preview controlado
;; ---------------------------------------------------------

(use-package consult
  :bind
  (("C-x b"   . consult-buffer)
   ("C-x C-r" . consult-recent-file)
   ("M-y"     . consult-yank-pop))
  :config
  ;; integração correta com completion
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply #'consult-completion-in-region args)))

  (consult-customize
   consult-ripgrep
   consult-git-grep
   consult-grep
   consult-recent-file
   consult-bookmark
   :preview-key "C-SPC")

  (consult-customize
   consult-theme
   :preview-key (list "C-SPC" :debounce 0.5 'any)))

;; ---------------------------------------------------------
;; Savehist — histórico do minibuffer
;; ---------------------------------------------------------

(use-package savehist
  :ensure nil
  :init
  (savehist-mode 1))

;; ---------------------------------------------------------
;; Marginalia — descrições ricas
;; ---------------------------------------------------------

(use-package marginalia
  
  :after vertico
  :init
  (marginalia-mode 1))

;; ---------------------------------------------------------
;; Embark — ações contextuais
;; ---------------------------------------------------------

(use-package embark
  
  :bind
  (("C-."   . embark-act)
   ("C-;"   . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  ;; substitui o describe-bindings padrão
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; evita poluir o minibuffer
  (setq embark-verbose-indicator-display-action
        '(display-buffer-at-bottom)))

;; ---------------------------------------------------------
;; Integração Embark + Consult
;; ---------------------------------------------------------

(use-package embark-consult
  
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; =========================================================
;; 6. FERRAMENTAS (GIT / PROJETOS)
;; =========================================================

;; ---------------------------------------------------------
;; Magit — Git sério
;; ---------------------------------------------------------

(use-package magit
  :commands (magit-status)
  :custom
  (magit-display-buffer-function
   #'magit-display-buffer-same-window-except-diff-v1))

(setq vc-handled-backends nil)


;; ---------------------------------------------------------
;; hl-todo — destaque de TODO/FIXME
;; ---------------------------------------------------------

(use-package hl-todo
  
  :hook ((prog-mode org-mode) . hl-todo-mode))

;; ---------------------------------------------------------
;; Projectile — projetos
;; ---------------------------------------------------------

(use-package projectile
  
  :init
  (projectile-mode 1)
  :custom
  (projectile-enable-caching t
                             projectile-completion-system 'default
                             projectile-project-search-path
                             '("~/development/"
                               "~/projects/"
                               "~/workspace/")))

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))  ; pick your own prefix key here
  :init
  (persp-mode))

;; (tab-bar-mode 1)
;; (with-eval-after-load 'evil
;;   (define-key evil-normal-state-map (kbd "SPC TAB n") #'tab-bar-new-tab)
;;   (define-key evil-normal-state-map (kbd "SPC TAB r") #'tab-bar-rename-tab)
;;   (define-key evil-normal-state-map (kbd "SPC TAB d") #'tab-bar-close-tab)
;;   (define-key evil-normal-state-map (kbd "SPC TAB ]") #'tab-bar-switch-to-next-tab)
;;   (define-key evil-normal-state-map (kbd "SPC TAB [") #'tab-bar-switch-to-prev-tab))

;; ---------------------------------------------------------
;; Consult + Projectile
;; ---------------------------------------------------------

(use-package consult-projectile
  
  :after (consult projectile))

;; =========================================================
;; 7. ORG MODE (ISOLADO E LIMPO)
;; =========================================================

;; ---------------------------------------------------------
;; Org core
;; ---------------------------------------------------------

(use-package org
  
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :config
  (setq org-directory "~/org/"
        org-default-notes-file
        (expand-file-name "inbox.org" org-directory)

        ;; visual
        org-ellipsis " ▼ "
        org-hide-emphasis-markers t

        ;; logging
        org-log-done 'time
        org-log-into-drawer t

        ;; fonte e realce
        org-fontify-quote-and-verse-blocks t
        org-fontify-done-headline t
        org-fontify-whole-heading-line t
        org-fontify-whole-block-delimiter-line t

        ;; estados de tarefa
        org-todo-keywords
        '((sequence
           "TODO(t)"
           "IN-PROGRESS(i)"
           "WAIT(w)"
           "PROJ(p)"
           "|"
           "DONE(d)"
           "CANCELLED(c)"))))

;; ---------------------------------------------------------
;; Visual moderno (Doom-like)
;; ---------------------------------------------------------

;; garante que nada antigo interfira
(setq org-superstar-headline-bullets-list nil)

(use-package org-modern
  
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-table t
        org-modern-hide-stars nil
        org-modern-star '("◉" "●" "○" "◆")
        org-modern-list '((?- . "•") (?+ . "◦") (?* . "‣"))
        org-modern-variable-pitch nil))

;; ---------------------------------------------------------
;; Faces (hierarquia Doom-like)
;; ---------------------------------------------------------

(custom-set-faces
 '(outline-1 ((t (:foreground "#51afef" :weight bold :height 1.3))))
 '(outline-2 ((t (:foreground "#c678dd" :weight bold :height 1.2))))
 '(outline-3 ((t (:foreground "#98be65" :weight bold :height 1.15))))
 '(outline-4 ((t (:foreground "#da8548" :weight bold :height 1.1))))
 '(outline-5 ((t (:foreground "#5699af"))))
 '(outline-6 ((t (:foreground "#46d9ff"))))
 '(outline-7 ((t (:foreground "#a9a1e1"))))
 '(outline-8 ((t (:foreground "#ecbe7b"))))
 '(org-document-title ((t (:height 1.5 :weight bold))))
 '(org-checkbox ((t (:height 1.2)))))

;; ---------------------------------------------------------
;; Auto-tangle (opcional, controlado)
;; ---------------------------------------------------------

(use-package org-auto-tangle
  
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun bashln/org-insert-auto-tangle-tag ()
  "Insere #+auto_tangle: t no início do arquivo."
  (interactive)
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (insert "#+auto_tangle: t\n"))))

;; =========================================================
;; 8.1 IDE — COMPLETION IN-BUFFER (CORFU)
;; =========================================================

;; ---------------------------------------------------------
;; Corfu
;; ---------------------------------------------------------

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-min-width 30)
  (corfu-max-width 80)
  (tab-always-indent 'complete))

(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "C-SPC") #'corfu-complete))

;; ---------------------------------------------------------
;; Cape — fallback inteligente
;; ---------------------------------------------------------

(use-package cape
  :after corfu
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(with-eval-after-load 'cape
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-nonexclusive))

(defun bashln/corfu-dabbrev-or-next (&optional arg)
  "Abre completion via dabbrev se não houver popup, senão navega."
  (interactive "p")
  (if corfu--candidates
      (corfu-next arg)
    (require 'cape)
    (cape-dabbrev t)
    (when (> corfu--total 0)
      (corfu--goto (or arg 0)))))

(defun bashln/corfu-dabbrev-or-prev (&optional arg)
  "Abre completion via dabbrev se não houver popup, senão navega."
  (interactive "p")
  (if corfu--candidates
      (corfu-previous arg)
    (require 'cape)
    (cape-dabbrev t)
    (when (> corfu--total 0)
      (corfu--goto (- corfu--total (or arg 1))))))

(defun bashln/corfu-dabbrev-this-buffer ()
  "Completa palavras apenas do buffer atual."
  (interactive)
  (require 'cape)
  (let ((cape-dabbrev-check-other-buffers nil))
    (cape-dabbrev t)))

(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "C-n") #'bashln/corfu-dabbrev-or-next)
  (define-key corfu-map (kbd "C-p") #'bashln/corfu-dabbrev-or-prev))


;; ---------------------------------------------------------
;; Ícones no popup
;; ---------------------------------------------------------

(use-package nerd-icons-corfu
  
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters
               #'nerd-icons-corfu-formatter))

;; =========================================================
;; 8.2 IDE — FORMATADORES (APHELEIA)
;; =========================================================

(use-package apheleia
  
  :config
  ;; habilita globalmente
  (apheleia-global-mode +1)

  ;; -------------------------------------------------------
  ;; Definição dos formatadores
  ;; -------------------------------------------------------

  ;; Prettier (JS / TS / Web)
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))

  ;; Black (Python)
  (setf (alist-get 'black apheleia-formatters)
        '("black" "--quiet" "-"))

  ;; -------------------------------------------------------
  ;; Associação modo → formatador
  ;; -------------------------------------------------------

  (setf (alist-get 'js-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'typescript-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'json-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'css-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'web-mode apheleia-mode-alist) 'prettier)

  (setf (alist-get 'python-mode apheleia-mode-alist) 'black))

;; =========================================================
;; 8.3 IDE — LSP (Infraestrutura) 
;; =========================================================

(setq read-process-output-max (* 1024 1024))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-idle-delay 0.5
        lsp-auto-shutdown t
        lsp-restart 'auto-restart

        ;; editor manda
        lsp-enable-on-type-formatting nil
        lsp-enable-indentation nil
        lsp-headerline-breadcrumb-enable nil
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil)

  :config
  ;; nunca usar servidores legados
  (setq lsp-disabled-clients
        '(javascript-typescript-langserver ts-ls))

  ;; registra vtsls corretamente (API oficial)
  (with-eval-after-load 'lsp-mode
    ;; desativa servidores legados
    (setq lsp-disabled-clients
          '(javascript-typescript-langserver ts-ls))

    ;; registra vtsls por MAJOR MODE (robusto)
    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection '("vtsls" "--stdio"))
      :major-modes '(js-ts-mode
                     typescript-ts-mode
                     tsx-ts-mode)
      :server-id 'vtsls)))
  )

(use-package mason
  :ensure t
  :config
  (mason-ensure))

;; =========================================================
;; 8.4 IDE — JavaScript / TypeScript (vtsls)
;; =========================================================

;; Indentação padrão
(setq js-indent-level 2
      typescript-indent-level 2)

(with-eval-after-load 'lsp-mode
  (defvar lsp-server-programs nil))

;; Hooks LSP (somente onde importa)
(add-hook 'js-ts-mode-hook #'lsp-deferred)
(add-hook 'tsx-ts-mode-hook #'lsp-deferred)
(add-hook 'typescript-ts-mode-hook #'lsp-deferred)

;; UX TS/JS
(with-eval-after-load 'lsp-mode
  (setq lsp-typescript-suggest-auto-imports t
        lsp-typescript-update-imports-on-file-move 'always
        lsp-typescript-format-enable nil
        lsp-javascript-format-enable nil
        lsp-enable-file-watchers nil
        lsp-completion-enable-additional-text-edit t))

;; HTML / CSS
(add-hook 'web-mode-hook #'lsp-deferred)

(with-eval-after-load 'lsp-mode
  (setq lsp-html-format-enable nil
        lsp-css-format-enable nil))

;; JSON (tree-sitter)
(add-hook 'json-mode-hook #'lsp-deferred)

(add-hook 'python-mode-hook #'lsp-deferred)

(with-eval-after-load 'lsp-mode
  (setq lsp-pyright-typechecking-mode "basic"
        lsp-pyright-use-library-code-for-types t))

(use-package lsp-java
  :after lsp-mode
  :hook (java-mode . lsp-deferred)
  :config
  (setq lsp-java-format-enabled nil))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable nil))

;; =========================================================
;; 8.5 IDE — COPILOT
;; =========================================================

(use-package copilot
  
  :hook
  (prog-mode . copilot-mode)
  :bind
  (:map copilot-completion-map
        ("<tab>" . copilot-accept-completion)
        ("TAB"   . copilot-accept-completion)
        ("C-TAB" . copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t))

;; =========================================================
;; 8.6 IDE — TREE-SITTER (TREESIT)
;; =========================================================

(when (treesit-available-p)
  ;; Highlight no nível do Doom
  (setq treesit-font-lock-level 4))

(use-package treesit-auto
  :demand t
  :custom
  (treesit-auto-install 'prompt)
  :config
  ;; remapeia tudo automaticamente
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; =========================================================
;; 9. NAVEGAÇÃO — TREEMACS
;; =========================================================

;; ---------------------------------------------------------
;; Treemacs — árvore de arquivos
;; ---------------------------------------------------------

(use-package treemacs
  
  :commands (treemacs treemacs-select-window)
  :config
  ;; comportamento previsível
  (setq treemacs-is-never-other-window t
        treemacs-width 30
        treemacs-collapse-dirs 3
        treemacs-follow-after-init nil
        treemacs-no-png-images nil))

;; ---------------------------------------------------------
;; Integração com Evil
;; ---------------------------------------------------------

(use-package treemacs-evil
  
  :after (treemacs evil))

;; =========================================================
;; 10. DASHBOARD (STARTUP)
;; =========================================================

(use-package dashboard
  :after evil
  :init
  (setq dashboard-startup-banner 'logo
        dashboard-banner-logo-title "Welcome to Bashln Emacs"
        dashboard-center-content t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents  . 5)
                          (projects . 5)))
  :config
  (dashboard-setup-startup-hook)

  (add-hook 'after-init-hook
            (lambda ()
              (recentf-save-list)
              (dashboard-refresh-buffer)
              (switch-to-buffer "*dashboard*"))))

;; ---------------------------------------------------------
;; Evil bindings dentro do Dashboard
;; ---------------------------------------------------------

(with-eval-after-load 'dashboard
  (with-eval-after-load 'evil
    (evil-define-key 'motion dashboard-mode-map
      (kbd "j")   #'dashboard-next-line
      (kbd "k")   #'dashboard-previous-line
      (kbd "r")   #'dashboard-refresh-buffer
      (kbd "RET") #'dashboard-return
      (kbd "SPC") nil)))

;; ---------------------------------------------------------
;; Diretório base correto
;; ---------------------------------------------------------

(defun bashln/dashboard-set-default-directory ()
  "Força o dashboard a usar ~/ como diretório base."
  (setq default-directory (expand-file-name "~/")))

(add-hook 'dashboard-mode-hook #'bashln/dashboard-set-default-directory)

;; =========================================================
;; JavaScript / TypeScript — Tree-sitter nativo (Emacs 29+)
;; =========================================================

(defun bashln/javascript-common-setup ()
  "Configurações comuns para JavaScript e TypeScript."
  ;; indentação melhor para chains
  (setq-local js-chain-indent t)

  ;; adiciona node_modules/.bin ao PATH
  (bashln/javascript-add-npm-path))

;; ---------------------------------------------------------
;; JavaScript (js-ts-mode)
;; ---------------------------------------------------------

(use-package js
  :ensure nil
  :mode ("\\.[mc]?js\\'" . js2-mode)
  :hook (js2-mode . bashln/javascript-common-setup)
  :config
  (setq js-indent-level 2))

(use-package json-mode
  :ensure nil
  :mode "\\.json\\'"
  :hook (json-mode . bashln/javascript-common-setup)
  :config
  (setq json-indent-offset 2))

;; ---------------------------------------------------------
;; TypeScript (typescript-ts-mode)
;; ---------------------------------------------------------

(use-package typescript-ts-mode
  :ensure nil
  :mode "\\.ts\\'"
  :hook (typescript-ts-mode . bashln/javascript-common-setup)
  :config
  (setq typescript-indent-level 2))

;; ---------------------------------------------------------
;; TSX / JSX (tsx-ts-mode) — builtin
;; ---------------------------------------------------------

(use-package tsx-ts-mode
  :ensure nil
  :mode "\\.[tj]sx\\'"
  :hook (tsx-ts-mode . bashln/javascript-common-setup))

;; =========================================================
;; Node.js tooling
;; =========================================================

(use-package nodejs-repl
  :commands nodejs-repl)

;; ---------------------------------------------------------
;; Compilation — stacktrace Node.js reconhecida
;; ---------------------------------------------------------

(with-eval-after-load 'compile
  (add-to-list 'compilation-error-regexp-alist 'node)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(node
                 "^[[:blank:]]*at \\(.*(\\|\\)\\(.+?\\):\\([0-9]+\\):\\([0-9]+\\)"
                 2 3 4)))

;; =========================================================
;; Helpers npm / projeto
;; =========================================================

(defvar bashln/javascript-npm-cache (make-hash-table :test 'equal))

(defun bashln/project-root ()
  "Retorna a raiz do projeto atual."
  (if-let ((proj (project-current)))
      (project-root proj)
    default-directory))

(defun bashln/javascript-read-package-json (&optional refresh)
  "Lê o package.json do projeto atual com cache."
  (let* ((root (bashln/project-root))
         (cached (gethash root bashln/javascript-npm-cache)))
    (if (and cached (not refresh))
        cached
      (let ((file (expand-file-name "package.json" root)))
        (when (file-exists-p file)
          (require 'json)
          (let ((json (json-read-file file)))
            (puthash root json bashln/javascript-npm-cache)
            json))))))

(defun bashln/javascript-npm-dep-p (package)
  "Retorna non-nil se PACKAGE existir em dependencies ou devDependencies."
  (when-let* ((data (bashln/javascript-read-package-json))
              (deps (append (cdr (assq 'dependencies data))
                            (cdr (assq 'devDependencies data)))))
    (assq package deps)))

(defun bashln/javascript-add-npm-path ()
  "Adiciona node_modules/.bin ao exec-path local."
  (when-let* ((root (bashln/project-root))
              (nm (locate-dominating-file root "node_modules/"))
              (bin (expand-file-name "node_modules/.bin" nm)))
    (make-local-variable 'exec-path)
    (add-to-list 'exec-path bin)))

(defun bashln/javascript-open-repl ()
  "Abre um REPL Node.js."
  (interactive)
  (nodejs-repl))


;; =========================================================
;; workspace
;; =========================================================

(use-package perspective
  :init
  (persp-mode 1)
  :custom
  (persp-show-modestring nil) ; Doom esconde isso da modeline
  :config
  ;; Integração com Projectile: ao trocar de projeto, troca o workspace
  (setq projectile-switch-project-action 'persp-switch-last-path)
  
  ;; Hook para garantir que cada projeto Projectile tenha seu próprio perspective
  (add-hook 'projectile-after-switch-project-hook
            (lambda ()
              (persp-switch (projectile-project-name)))))







(provide 'config)
;;; config.el ends here
