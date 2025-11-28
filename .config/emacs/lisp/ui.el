
;;; ui.el --- Interface e experiência visual -*- lexical-binding: t; -*-
;;; Commentary:
;; Interface moderna ao estilo Doom:
;; - Tema Doom
;; - Modeline profissional
;; - Ícones
;; - Indent guides modernos
;; - Treemacs estilizado
;; - Popper
;; - Tildes estilo Vim
;; - Interface minimalista

;;; Code:

;; ---------------------------------------------------------------------------
;; Fontes
;; ---------------------------------------------------------------------------

(set-face-attribute 'default nil :family "Maple Mono" :height 120)
(set-face-attribute 'fixed-pitch nil :family "Maple Mono" :height 120)

;; Se quiser títulos mais bonitos, trocamos depois:
(set-face-attribute 'variable-pitch nil :family "Maple Mono" :height 130)

;; ---------------------------------------------------------------------------
;; Tema Doom
;; ---------------------------------------------------------------------------

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config)
  (doom-themes-treemacs-config))

;; ---------------------------------------------------------------------------
;; Doom Modeline
;; ---------------------------------------------------------------------------

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 18)
  (doom-modeline-icon t))

;; ---------------------------------------------------------------------------
;; Ícones
;; ---------------------------------------------------------------------------

(use-package all-the-icons
  :if (display-graphic-p))

;; ---------------------------------------------------------------------------
;; hl-todo
;; ---------------------------------------------------------------------------

(use-package hl-todo
  :hook ((prog-mode text-mode) . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"))

;; ---------------------------------------------------------------------------
;; Indent guides modernos (substitui indent-guide)
;; ---------------------------------------------------------------------------

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-character ?│)
  (highlight-indent-guides-responsive 'top))

;; ---------------------------------------------------------------------------
;; Popper (janela popup estilo Doom)
;; ---------------------------------------------------------------------------

(use-package popper
  :bind (("C-`" . popper-toggle)
         ("M-`" . popper-cycle))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "\\*Warnings\\*"
          help-mode
          compilation-mode))
  :config
  (popper-mode +1)
  (popper-echo-mode +1))

;; ---------------------------------------------------------------------------
;; Tildes estilo Vim
;; ---------------------------------------------------------------------------

(use-package vi-tilde-fringe
  :hook (prog-mode . vi-tilde-fringe-mode))

;; ---------------------------------------------------------------------------
;; Treemacs
;; ---------------------------------------------------------------------------

(use-package treemacs
  :defer t
  :config
  (setq treemacs-collapse-dirs 3
        treemacs-width 30))

(use-package treemacs-all-the-icons
  :after treemacs
  :config
  (treemacs-load-theme "all-the-icons"))

;; ---------------------------------------------------------------------------
;; Interface minimalista
;; ---------------------------------------------------------------------------

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Mantém a fringe para vi-tilde-fringe funcionar
(set-fringe-mode '(8 . 8))

(pixel-scroll-precision-mode 1)

(setq frame-title-format "%b")

(provide 'ui)
;;; ui.el ends here
