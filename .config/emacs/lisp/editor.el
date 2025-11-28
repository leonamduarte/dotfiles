
;;; editor.el --- Comportamento geral do editor ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo fornece:
;; - Smartparens completo
;; - Yasnippet
;; - Undo avançado
;; - Folding universal
;; - Auto-format on save (Apheleia)
;; - Indentação sensata
;; - Limpeza de whitespace
;; - Navegação, comentários e edição modal
;; - Which-key ao estilo Doom

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smartparens (Doom: :editor smartparens)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package smartparens
  :hook ((prog-mode . smartparens-mode)
         (text-mode . smartparens-mode))
  :config
  (require 'smartparens-config)

  ;; Highlights iguais ao Doom
  (setq sp-highlight-pair-overlay t)

  ;; Ajustes adicionais (JSX, HTML, etc.)
  (sp-local-pair 'jsx-mode "<" ">")
  (sp-local-pair 'web-mode "<" ">")
  (sp-local-pair 'typescript-ts-mode "<" ">")

  ;; Navegação inteligente (C-M-f, C-M-b)
  (sp-use-smartparens-bindings))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Snippets (Doom: :editor snippets)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package yasnippet
  :hook ((prog-mode . yas-minor-mode)
         (text-mode . yas-minor-mode))
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Undo avançado (Doom: :emacs undo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package undo-fu)
(use-package undo-fu-session
  :hook (after-init . undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-directory
        (expand-file-name "undo-fu-session/" user-emacs-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fold universal (Doom: :editor fold)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package hideshow
  :hook (prog-mode . hs-minor-mode)
  :config
  ;; Atalhos Doom/Vim-like
  (define-key hs-minor-mode-map (kbd "C-c h") #'hs-toggle-hiding)
  (define-key hs-minor-mode-map (kbd "C-c H") #'hs-hide-all)
  (define-key hs-minor-mode-map (kbd "C-c S") #'hs-show-all))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Formatação automática — Doom: :editor format +onsave
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package apheleia
  :hook (prog-mode . apheleia-mode)
  :config
  (apheleia-global-mode +1)

  ;; Formatos ignorados ou perigosos
  (setq apheleia-formatter-excluded-modes
        '(org-mode text-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação e whitespace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Limpeza de espaços
(use-package ws-butler
  :hook ((text-mode prog-mode) . ws-butler-mode))

;; Identação sensata
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 100)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Melhor navegação entre linhas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq line-move-visual nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlight parent
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq show-paren-delay 0)
(show-paren-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Comentários
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Você usa evil-commentary, então M-/ vira redundante,
;; mas deixo como fallback universal.
(global-set-key (kbd "M-/") #'comment-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Recent files (igual Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package recentf
  :init (recentf-mode 1)
  :config
  (setq recentf-max-saved-items 200
        recentf-auto-cleanup 'never))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Which-key (Doom ativa como parte do core)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.4
        which-key-sort-order 'which-key-prefix-then-key-order
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.33))

(provide 'editor)
;;; editor.el ends here
