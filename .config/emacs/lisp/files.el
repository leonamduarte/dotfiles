
;;; files.el --- Dired moderno ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - Navegação h/l estilo Ranger
;; - Dired single-buffer
;; - Ícones (nerd-icons)
;; - Git info inline
;; - Cores diredfl
;; - Peep-dired
;; - Integração total com Evil

;;; Code:

;; ----------------------------------------------------------------------------
;; Dired core
;; ----------------------------------------------------------------------------

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-listing-switches
   ;; fallback para Windows = remove "--group-directories-first"
   (if (eq system-type 'windows-nt)
       "-alh"
     "-alh --group-directories-first"))
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-auto-revert-buffer t)

  :bind
  (("SPC f d" . dired))

  :hook
  (dired-mode . leo/dired-setup))

(defun leo/dired-setup ()
  "Configurações Doom-like para Dired."
  ;; Navegação estilo ranger
  (define-key dired-mode-map (kbd "h") #'dired-up-directory)
  (define-key dired-mode-map (kbd "l") #'dired-find-file)

  ;; Q para sair como no ranger
  (define-key dired-mode-map (kbd "q") #'quit-window)

  ;; ^ volta ao diretório pai (Doom-like)
  (define-key dired-mode-map (kbd "^") #'dired-up-directory)

  ;; NÃO deixar o Evil Collection sobrescrever isso
  (let ((m dired-mode-map))
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" #'dired-up-directory
      "l" #'dired-find-file)))

;; ----------------------------------------------------------------------------
;; Ícones nerd-icons
;; ----------------------------------------------------------------------------

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;; ----------------------------------------------------------------------------
;; Dired single-buffer (estilo ranger)
;; ----------------------------------------------------------------------------

(use-package dired-single
  :hook
  (dired-mode . leo/dired-single-keys))

(defun leo/dired-single-keys ()
  (define-key dired-mode-map (kbd "l") #'dired-single-buffer)
  (define-key dired-mode-map (kbd "h") #'dired-single-up-directory))

;; ----------------------------------------------------------------------------
;; Cores adicionais
;; ----------------------------------------------------------------------------

(use-package diredfl
  :init
  (diredfl-global-mode 1))

;; ----------------------------------------------------------------------------
;; Peep-dired (preview estilo ranger)
;; ----------------------------------------------------------------------------

(use-package peep-dired
  :after dired
  :bind
  (:map dired-mode-map
        ("P" . peep-dired))
  :hook
  (peep-dired-mode . leo/peep-dired-enter))

(defun leo/peep-dired-enter ()
  ;; Desativa cursor para visual mais limpo
  (setq-local cursor-type nil)

  ;; Desativa line numbers relativos no preview (melhor leitura)
  (when (bound-and-true-p display-line-numbers)
    (setq-local display-line-numbers 'absolute))

  ;; Fechar preview com SPC, igual Doom
  (define-key peep-dired-mode-map (kbd "SPC") #'peep-dired))

;; ----------------------------------------------------------------------------
;; Git inline
;; ----------------------------------------------------------------------------

(use-package dired-git-info
  :after dired
  :bind
  (:map dired-mode-map
        (")" . dired-git-info-mode)))

;; ----------------------------------------------------------------------------
;; Alternar dotfiles
;; ----------------------------------------------------------------------------

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :bind
  (:map dired-mode-map
        ("." . dired-hide-dotfiles-mode)))

(provide 'files)
;;; files.el ends here
