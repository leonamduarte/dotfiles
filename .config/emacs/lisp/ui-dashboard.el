
;;; ui-dashboard.el --- Dashboard estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Dashboard completo com ícones, projetos, agenda, banner custom e integração
;; à experiência Doom.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dependência essencial (separa seções visualmente)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package page-break-lines
  :init (global-page-break-lines-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dashboard principal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :after page-break-lines
  :init
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-set-init-info t  ;; texto estilo Doom no fim
        dashboard-projects-backend 'project-el
        dashboard-items '((recents  . 8)
                          (projects . 5)
                          (agenda   . 5)))

  ;; Banner custom — opcional
  ;; (setq dashboard-startup-banner "/path/to/banner.png")

  :config
  ;; Hook oficial do dashboard
  (dashboard-setup-startup-hook)

  ;; Evita flash do buffer *scratch* no início
  (setq initial-buffer-choice
        (lambda () (get-buffer "*dashboard*"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ajustes gerais
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-startup-screen t)

(provide 'ui-dashboard)
;;; ui-dashboard.el ends here
