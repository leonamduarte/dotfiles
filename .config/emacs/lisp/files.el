;;; files.el --- Gerenciamento de arquivos (Dired) -*- lexical-binding: t; -*-

;;; Commentary:
;; Módulo que transforma o Dired em um gerenciador de arquivos moderno:
;; - navegação estilo ranger (h/l)
;; - preview com peep-dired
;; - ícones
;; - cores melhoradas
;; - git info inline
;; - esconder/mostrar dotfiles
;; - abrir diretórios sem poluir buffers, estilo "single buffer"

;;; Code:

;; ---------------------------------------------------------------------------
;; Núcleo do Dired
;; ---------------------------------------------------------------------------

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-listing-switches "-alh --group-directories-first")
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-auto-revert-buffer t)
  :bind
  (("SPC f d" . dired))        ;; abre o Dired rápido
  :hook
  (dired-mode . (lambda ()
                  (define-key dired-mode-map (kbd "h") #'dired-up-directory)
                  (define-key dired-mode-map (kbd "l") #'dired-find-file))))


;; ---------------------------------------------------------------------------
;; Ícones nerd-icons
;; ---------------------------------------------------------------------------

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))


;; ---------------------------------------------------------------------------
;; Abrir dired sempre no mesmo buffer (não polui a tela)
;; ---------------------------------------------------------------------------

(use-package dired-single
  :hook
  (dired-mode . (lambda ()
                  (define-key dired-mode-map (kbd "l") #'dired-single-buffer)
                  (define-key dired-mode-map (kbd "h") #'dired-single-up-directory))))


;; ---------------------------------------------------------------------------
;; Cores melhores para listagem
;; ---------------------------------------------------------------------------

(use-package diredfl
  :init
  (diredfl-global-mode 1))


;; ---------------------------------------------------------------------------
;; Preview de arquivos (tipo Ranger)
;; ---------------------------------------------------------------------------

(use-package peep-dired
  :hook
  (peep-dired-mode . (lambda ()
                       (setq-local cursor-type nil)))
  :bind
  (:map dired-mode-map
        ("P" . peep-dired)))


;; ---------------------------------------------------------------------------
;; Informações de Git inline
;; ---------------------------------------------------------------------------

(use-package dired-git-info
  :bind
  (:map dired-mode-map
        (")" . dired-git-info-mode)))


;; ---------------------------------------------------------------------------
;; Alternar exibição de arquivos ocultos
;; ---------------------------------------------------------------------------

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :bind
  (:map dired-mode-map
        ("." . dired-hide-dotfiles-mode)))

;;; files.el ends here
