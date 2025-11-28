;;; lang-org.el --- Org completo ao estilo Doom, para Emacs modular -*- lexical-binding: t; -*-

;;; Commentary:
;; Visual Doom-like:
;; - org-modern
;; - org-appear
;; - inline-images
;; - faces grandes estilo Doom
;; - org-roam
;; - tangle automático
;; - export via pandoc

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Base do Org
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode))
  :config
  (setq org-directory "~/org/"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-ellipsis " ▾ "
        org-startup-with-inline-images t
        org-image-actual-width '(300)
        org-log-done 'time
        org-log-into-drawer t
        org-table-convert-region-max-lines 20000
        org-todo-keywords
        '((sequence
           "TODO(t)" "BLOG(b)" "GYM(g)" "PROJ(p)"
           "VIDEO(v)" "WAIT(w)"
           "|" "DONE(d)" "CANCELLED(c)"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visual: org-modern + faces grandes estilo Doom
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package org-modern
;;   :hook (org-mode . org-modern-mode)
;;   :config
;;   (setq org-modern-star nil            ;; Doom-like (não mexe nos bullets)
;;         org-modern-hide-stars t
;;         org-modern-table t
;;         org-modern-block-fringe 8
;;         org-modern-table-vertical 1
;;         org-modern-horizontal-rule t))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("●" "○" "◆" "▶")
        org-superstar-itembullet-alist '((?* . ?•)
                                         (?+ . ?➤)
                                         (?- . ?✦))))


(add-hook 'org-mode-hook #'hl-todo-mode)

;; Headings grandes estilo Doom (sem superstar)
(custom-set-faces
 '(org-level-8 ((t (:inherit outline-3 :height 1.0))))
 '(org-level-7 ((t (:inherit outline-3 :height 1.0))))
 '(org-level-6 ((t (:inherit outline-3 :height 1.1))))
 '(org-level-5 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-3 :height 1.3))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.4))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
 '(org-level-1 ((t (:inherit outline-1 :height 1.6))))
 '(org-document-title ((t (:height 1.8 :weight bold :underline nil)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-appear (mostrar marcações ao editar)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-delay 0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-roam
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-roam
  :init
  (setq org-roam-directory (expand-file-name "~/org/roam"))
  :config
  (org-roam-db-autosync-mode)
  (setq org-roam-v2-ack t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-tangle (similar ao Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun leo/org-insert-auto-tangle ()
  "Insere #+auto_tangle: t na posição atual."
  (interactive)
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (insert "#+auto_tangle: t\n"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Export via Pandoc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ox-pandoc
  :after org)


(provide 'lang-org)
;;; lang-org.el ends here
