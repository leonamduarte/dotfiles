;;; config.el --- M  dulos e Plugins do Leonam -*- lexical-binding: t; coding: utf-8 -*-

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

(use-package recentf
  :init
  ;; 1. Habilita o modo
  (recentf-mode 1)

  :config
  ;; 2. Configuraes
  (setq recentf-max-saved-items 200
        recentf-max-menu-items 50
        recentf-auto-cleanup 'never
        recentf-exclude
        '("/tmp/" "/ssh:" "/sudo:" "\\.git/" "COMMIT_EDITMSG"))
  (add-hook 'kill-emacs-hook #'recentf-save-list)
  (run-at-time nil (* 5 60) #'recentf-save-list))

;; ---------------------------------------------------------
;; Organização de arquivos (no-littering)
;; ---------------------------------------------------------

(use-package no-littering
  
  :demand t
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))
        recentf-save-file
        (no-littering-expand-var-file-name "recentf")))

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
  (general-create-definer leonam/leader-keys
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
  (set-face-attribute 'default nil
                      :family "JetBrains Mono"
                      :height 130))

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

;; =========================================================
;; 5. COMPLETION STACK (VERTICO)
;; =========================================================

;; ---------------------------------------------------------
;; Vertico — UI do minibuffer
;; ---------------------------------------------------------

(use-package vertico
  
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

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
;; Orderless — estilo de matching
;; ---------------------------------------------------------

(use-package orderless
  
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

;; ---------------------------------------------------------
;; Consult — comandos poderosos
;; ---------------------------------------------------------

(use-package consult
  
  :bind
  (("C-x b"     . consult-buffer)
   ("C-x C-r"   . consult-recent-file)
   ("M-y"       . consult-yank-pop))
  :config
  (setq consult-preview-key 'any
        completion-in-region-function
        #'consult-completion-in-region))

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
        org-modern-hide-stars t
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

(defun leonam/org-insert-auto-tangle-tag ()
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
;; Corfu — completion leve e moderno
;; ---------------------------------------------------------

(use-package corfu
  
  :init
  (global-corfu-mode 1)
  :custom
  ;; sugestões automáticas, mas discretas
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)

  ;; navegação previsível
  (corfu-cycle t)
  (corfu-preselect 'prompt)

  ;; aparência
  (corfu-min-width 30)
  (corfu-max-width 80))

;; ---------------------------------------------------------
;; Integração com Evil (insert only)
;; ---------------------------------------------------------

(with-eval-after-load 'evil
  ;; chama completion manualmente se quiser
  (define-key evil-insert-state-map
              (kbd "C-SPC") #'completion-at-point))

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
;; 8.3 IDE — LSP (INTELIGÊNCIA)
;; =========================================================

;; ---------------------------------------------------------
;; lsp-mode — núcleo
;; ---------------------------------------------------------

(use-package lsp-mode
  
  :commands (lsp lsp-deferred)
  :hook
  ((prog-mode . lsp-deferred)
   ;; Emacs Lisp NÃO usa LSP
   (emacs-lisp-mode . (lambda ()
                        (setq-local lsp-enabled-clients nil))))
  :init
  ;; prefixo padrão (não usamos SPC aqui)
  (setq lsp-keymap-prefix "C-c l"

        ;; performance
        lsp-idle-delay 0.5
        read-process-output-max (* 1024 1024))

  :config
  ;; NÃO deixar o LSP mandar no editor
  (setq lsp-enable-on-type-formatting nil
        lsp-enable-indentation nil
        lsp-enable-symbol-highlighting t
        lsp-warn-no-matched-clients nil))

;; ---------------------------------------------------------
;; lsp-ui — UI auxiliar (hover, docs)
;; ---------------------------------------------------------

(use-package lsp-ui
  
  :after lsp-mode
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-enable nil)) ;; sideline costuma poluir

;; =========================================================
;; 8.4 IDE — LINGUAGENS (MODOS + LSP)
;; =========================================================

;; ---------------------------------------------------------
;; JavaScript / JSX (Windows-friendly)
;; ---------------------------------------------------------

(use-package js2-mode
  
  :hook
  (js-mode . js2-minor-mode)
  :config
  (setq js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil))

(setq js-indent-level 2)

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-mode))
;; ---------------------------------------------------------
;; TypeScript / TSX
;; ---------------------------------------------------------

(use-package typescript-mode
  
  :mode (("\\.ts\\'"  . typescript-mode)
         ("\\.tsx\\'" . typescript-mode)))

;; ---------------------------------------------------------
;; Web (HTML / CSS / PHP)
;; ---------------------------------------------------------

(use-package web-mode
  
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'"   . web-mode)
         ("\\.php\\'"   . web-mode))
  :config
  ;; melhor compatibilidade com LSP
  (setq web-mode-enable-auto-quoting nil))

;; ---------------------------------------------------------
;; JSON
;; ---------------------------------------------------------

(use-package json-mode
  
  :mode "\\.json\\'")

;; ---------------------------------------------------------
;; Python
;; ---------------------------------------------------------

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode))

;; ---------------------------------------------------------
;; Java (LSP dedicado)
;; ---------------------------------------------------------

(use-package lsp-java
  
  :after lsp-mode
  :hook (java-mode . lsp-deferred))

;; ---------------------------------------------------------
;; Lua
;; ---------------------------------------------------------

(use-package lua-mode
  
  :mode "\\.lua\\'")

;; ---------------------------------------------------------
;; Shell / Bash
;; ---------------------------------------------------------

(add-hook 'sh-mode-hook #'lsp-deferred)

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

;; ---------------------------------------------------------
;; Instalação automática de grammars
;; ---------------------------------------------------------

(use-package treesit-auto
  :ensure t
  :demand t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; ---------------------------------------------------------
;; Remapeamento de modos para Tree-sitter
;; ---------------------------------------------------------

(setq major-mode-remap-alist
      '((js-mode          . js-ts-mode)
        (typescript-mode  . typescript-ts-mode)
        (css-mode         . css-ts-mode)
        (json-mode        . json-ts-mode)))

;; JSX / TSX
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))


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
  
  :init
  ;; configuração visual e conteúdo
  (setq dashboard-startup-banner 'logo
        dashboard-banner-logo-title "Bem-vindo ao Emacs do Leonam"
        dashboard-center-content t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents  . 5)
                          (projects . 5)))
  :config
  ;; registra o dashboard no startup
  (dashboard-setup-startup-hook)

  ;; abre o dashboard APÓS o init completo
  (add-hook 'after-init-hook
            (lambda ()
              ;; garante que recentf esteja carregado
              (recentf-cleanup)
              (recentf-save-list)

              ;; agora sim renderiza o dashboard
              (dashboard-refresh-buffer)
              (switch-to-buffer "*dashboard*")))

  :after evil)

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

(defun leonam/dashboard-set-default-directory ()
  "Força o dashboard a usar ~/ como diretório base."
  (setq default-directory (expand-file-name "~/")))

(add-hook 'dashboard-mode-hook #'leonam/dashboard-set-default-directory)

(provide 'config)
;;; config.el ends here
