
;;; tools-git.el --- Git / Magit / Forge ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Integração completa com Git, Magit, Forge e Diff-HL
;; Sem duplicações e com carregamento inteligente.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :commands (magit-status magit-blame magit-diff magit-log-all)
  :init
  (autoload 'magit-status "magit")
  :config
  ;; janela fullframe para status (estilo Doom)
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Forge — GitHub/GitLab integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package forge
  :after magit
  ;; carregamento tardio, como no Doom
  :commands (forge-open-pullreq forge-dispatch))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; diff-hl — gutters estilo Doom
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; Somente no GUI (evita glitch em terminal)
  (when (display-graphic-p)
    (diff-hl-margin-mode 1))
  (diff-hl-flydiff-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil integration para Magit (estilo Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'magit
  (evil-collection-init 'magit))

(provide 'tools-git)
;;; tools-git.el ends here
