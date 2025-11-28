
;;; lang-org.el --- Org ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Setup visual e funcional inspirado no Doom:
;; - org-superstar
;; - faces grandes
;; - org-appear
;; - org-auto-tangle
;; - org-roam moderno
;; - export via pandoc
;; - integração com leader key

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org base
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode)
         (org-mode . leo/org-inline-image-refresh))
  :config
  (setq org-directory "~/org/"
        org-default-notes-file (expand-file-name "notes.org" org-directory)

        ;; Visual
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-ellipsis " ▾ "
        org-startup-with-inline-images t
        org-image-actual-width '(400)

        ;; Logs
        org-log-done 'time
        org-log-into-drawer t

        ;; Table optim
        org-table-convert-region-max-lines 20000

        ;; Todo keywords estilo Doom
        org-todo-keywords
        '((sequence
           "TODO(t)" "WAIT(w)" "PROJ(p)" "BLOG(b)" "GYM(g)" "VIDEO(v)"
           "|"
           "DONE(d)" "CANCELLED(c)"))))

(defun leo/org-inline-image-refresh ()
  "Atualiza imagens inline ao salvar/editar."
  (when org-startup-with-inline-images
    (org-display-inline-images)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visual: org-superstar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-remove-leading-stars t
        org-superstar-leading-bullet " "
        org-superstar-headline-bullets-list '("●" "○" "◆" "▶")
        org-superstar-itembullet-alist '((?* . ?•)
                                         (?+ . ?➤)
                                         (?- . ?✦))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Headings grandes estilo Doom (seguro pra temas)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/org-big-headings ()
  (custom-theme-set-faces
   'user
   '(org-level-8 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-7 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-6 ((t (:inherit outline-3 :height 1.1))))
   '(org-level-5 ((t (:inherit outline-3 :height 1.2))))
   '(org-level-4 ((t (:inherit outline-3 :height 1.3))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.4))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
   '(org-level-1 ((t (:inherit outline-1 :height 1.6))))
   '(org-document-title ((t (:height 1.8 :weight bold :underline nil))))))
(add-hook 'org-mode-hook #'leo/org-big-headings)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-appear — mostrar marcações somente ao editar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t
        org-appear-inside-latex t
        org-appear-delay 0.03))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-roam completo (estilo Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-roam
  :init
  (setq org-roam-directory (expand-file-name "~/org/roam"))
  :config
  (setq org-roam-v2-ack t)

  ;; Indexação automática
  (org-roam-db-autosync-mode)

  ;; Templates clássicos Doom
  (setq org-roam-capture-templates
        '(("d" "Default" plain "%?"
           :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n")
           :unarrowed t)

          ("l" "Literature" plain "%?"
           :if-new (file+head "lit-${slug}.org"
                              "#+title: ${title}\n#+filetags: :lit:\n")
           :unarrowed t)

          ("p" "Project" plain "%?"
           :if-new (file+head "proj-${slug}.org"
                              "#+title: ${title}\n#+filetags: :proj:\n")
           :unarrowed t)))

  ;; Consult integration
  (use-package consult-org-roam
    :after org-roam
    :init (consult-org-roam-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto-tangle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun leo/org-insert-auto-tangle ()
  "Insere #+auto_tangle: t na posição atual."
  (interactive)
  (save-excursion
    (insert "#+auto_tangle: t\n")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Export via Pandoc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ox-pandoc :after org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Atalhos Doom-like
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-key leo/leader-org-map (kbd "t") #'org-babel-tangle)
  (define-key leo/leader-org-map (kbd "e") #'org-export-dispatch)
  (define-key leo/leader-org-map (kbd "n") #'org-roam-capture)
  (define-key leo/leader-org-map (kbd "f") #'org-roam-node-find)
  (define-key leo/leader-org-map (kbd "i") #'org-roam-node-insert))

(provide 'lang-org)
;;; lang-org.el ends here
