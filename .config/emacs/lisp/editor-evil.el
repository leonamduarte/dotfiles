
;;; editor-evil.el --- Vim everywhere ao estilo Doom -*- lexical-binding: t; -*-

;;; Commentary:
;; Evil configurado de forma parecida com Doom:
;; - Estados modais completos
;; - Integração ampla com modos Emacs
;; - Surround, commentary, matchit
;; - Linhas relativas dinâmicas
;; - Movimentação suave de splits
;; - ESC universal realmente universal
;; - Treemacs + Evil

;;; Code:

;; ----------------------------------------------------------------------------
;; Evil básico
;; ----------------------------------------------------------------------------

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil      ;; necessário para evil-collection
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-want-C-i-jump t
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-fu)

  :config
  (evil-mode 1)

  ;; Cursor shapes ao estilo vim
  (setq evil-normal-state-cursor '(box  "#ffcc00")
        evil-insert-state-cursor '(bar  "#00ccff")
        evil-visual-state-cursor '(hbar "#ff66aa"))

  ;; Linhas relativas DINÂMICAS
  (setq display-line-numbers-type 'relative)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode)

  (add-hook 'evil-insert-state-entry-hook
            (lambda ()
              (setq display-line-numbers 'absolute)))

  (add-hook 'evil-normal-state-entry-hook
            (lambda ()
              (setq display-line-numbers 'relative)))

  ;; Movimentação entre splits estilo Vim
  (define-key evil-normal-state-map (kbd "C-h") #'windmove-left)
  (define-key evil-normal-state-map (kbd "C-j") #'windmove-down)
  (define-key evil-normal-state-map (kbd "C-k") #'windmove-up)
  (define-key evil-normal-state-map (kbd "C-l") #'windmove-right)

  ;; Splits estilo Vim
  (setq evil-split-window-below t
        evil-vsplit-window-right t))

;; ----------------------------------------------------------------------------
;; Evil Collection (integra Emacs inteiro ao Evil)
;; ----------------------------------------------------------------------------

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ----------------------------------------------------------------------------
;; Surround (como no Doom)
;; ----------------------------------------------------------------------------

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

;; ----------------------------------------------------------------------------
;; Commentary (gc para comentar linhas)
;; ----------------------------------------------------------------------------

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

;; ----------------------------------------------------------------------------
;; Matchit (% para pular entre pares)
;; ----------------------------------------------------------------------------

(use-package evil-matchit
  :after evil
  :config
  (global-evil-matchit-mode 1))

;; ----------------------------------------------------------------------------
;; ESC universal (fecha TUDO)
;; ----------------------------------------------------------------------------

(defun leo/escape-everywhere ()
  (interactive)
  ;; tenta fechar minibufer primeiro
  (cond
   ((minibufferp) (abort-recursive-edit))
   ;; tenta kill current transient UI
   ((and (boundp 'corfu-mode) corfu-mode) (corfu-quit))
   ((bound-and-true-p vertico--input) (vertico-exit))
   (t (keyboard-escape-quit))))

(global-set-key (kbd "<escape>") #'leo/escape-everywhere)

;; ----------------------------------------------------------------------------
;; Treemacs + Evil
;; ----------------------------------------------------------------------------

(use-package treemacs-evil
  :after (treemacs evil))

(global-set-key (kbd "C-c t") #'treemacs)

;; ----------------------------------------------------------------------------
;; jk como ESC (opcional Doom)
;; ----------------------------------------------------------------------------

;; (use-package evil-escape
;;   :after evil
;;   :config
;;   (evil-escape-mode)
;;   (setq evil-escape-key-sequence "jk"
;;         evil-escape-delay 0.15))

(provide 'editor-evil)
;;; editor-evil.el ends here
