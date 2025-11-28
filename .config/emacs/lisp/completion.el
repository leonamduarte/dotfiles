
;;; completion.el --- Vertico/Consult/Corfu ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Sistema de completions moderno inspirado no Doom:
;; - Vertico + Orderless
;; - Marginalia
;; - Consult + Embark
;; - Corfu (in-buffer)
;; - Ícones no minibuffer
;;
;;; Code:

(require 'cl-lib)

;; ----------------------------------------------------------------------------
;; Vertico
;; ----------------------------------------------------------------------------

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

;; ----------------------------------------------------------------------------
;; Marginalia
;; ----------------------------------------------------------------------------

(use-package marginalia
  :init
  (marginalia-mode))

;; ----------------------------------------------------------------------------
;; Orderless (matching moderno)
;; ----------------------------------------------------------------------------

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles orderless partial-completion)))))

;; ----------------------------------------------------------------------------
;; Consult
;; ----------------------------------------------------------------------------

(use-package consult
  :bind
  (("C-s"     . consult-line)
   ("C-x b"   . consult-buffer)
   ("C-c k"   . consult-ripgrep)
   ("C-x C-r" . consult-recent-file)
   ("M-y"     . consult-yank-pop)))

;; ----------------------------------------------------------------------------
;; Embark (ações contextuais)
;; ----------------------------------------------------------------------------

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; ----------------------------------------------------------------------------
;; Ícones no minibuffer (consult + marginalia)
;; ----------------------------------------------------------------------------

(use-package all-the-icons-completion
  :if (display-graphic-p)
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; ----------------------------------------------------------------------------
;; Corfu — completion in-buffer (VSCode vibe)
;; ----------------------------------------------------------------------------

(use-package corfu
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode 1)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-popupinfo-delay 0.2)
  :config
  ;; Navegação estilo Vim/VSCode
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous)

  ;; Melhor integração no minibuffer
  (defun leo/corfu-enable-in-minibuffer ()
    (setq-local corfu-auto nil)
    (corfu-mode 1))
  (add-hook 'minibuffer-setup-hook #'leo/corfu-enable-in-minibuffer))

;; ----------------------------------------------------------------------------
;; Ajustes gerais de completion
;; ----------------------------------------------------------------------------

(setq completion-cycle-threshold 3)

(provide 'completion)
;;; completion.el ends here

