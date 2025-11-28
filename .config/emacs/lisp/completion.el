;;; completion.el --- Completions e navegação moderna -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo ativa:
;; - Vertico: minibuffer vertical moderno
;; - Orderless: matching inteligente
;; - Marginalia: descrições nas listas
;; - Consult: comandos avançados de navegação
;; - Embark: ações contextuais (opcional, mas recomendado)
;; - Corfu: completions in-buffer (opcional, estilo VSCode)
;; - Ícones no minibuffer (all-the-icons-completion)
;;
;; É o equivalente ao módulo Doom :completion vertico +icons.

;;; Code:

;; Vertico
(use-package vertico
  :init
  (vertico-mode 1))

;; All the icons
(use-package all-the-icons
  :ensure nil)

;; Ícones no minibuffer
(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

;; Orderless
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil))

;; Marginalia
(use-package marginalia
  :init (marginalia-mode))

;; Consult
(use-package consult
  :bind (("C-s" . consult-line)
         ("C-p" . consult-buffer)
         ("C-M-l" . consult-imenu)
         ("M-g g" . consult-goto-line)))

;; Embark
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Corfu

(use-package corfu
  :init
  (global-corfu-mode)

  ;; Ativa o popupinfo integrado
  (corfu-popupinfo-mode 1)

  :custom
  (corfu-popupinfo-delay 0.5)
  (corfu-popupinfo-max-width 70)
  (corfu-popupinfo-max-height 20))


;; Ajustes gerais de completion
(setq completion-cycle-threshold 3)

(provide 'completion)
;;; completion.el ends here
