;;; ui-dashboard.el --- Dashboard oficial estilo Doom -*- lexical-binding: t; -*-

;;; Commentary:
;; Usa o dashboard oficial do GitHub (emacs-dashboard).
;; Inclui ícones, recentes, projetos, agenda e banner.
;; Carrega automaticamente no startup.

;;; Code:

(use-package dashboard
  :init
  ;; Configurações antes do load
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents . 8)
                          (projects . 5)
                          (agenda . 5)))
  :config
  ;; Inicializa o dashboard corretamente
  (dashboard-setup-startup-hook)

  ;; Garante que ele seja o buffer inicial REAL
  (setq initial-buffer-choice #'dashboard-refresh-buffer))

;; Evita tela padrão do Emacs
(setq inhibit-startup-screen t)

(provide 'ui-dashboard)

;;; ui-dashboard.el ends here
