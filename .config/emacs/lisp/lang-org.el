;;; lang-org.el --- Org-mode completo ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo traz:
;; - Org com visual moderno
;; - Org-bullets (ícones)
;; - Org-appear (animações)
;; - Org-tempo (atalhos <s TAB etc)
;; - Org-roam
;; - Export via Pandoc
;; - Journaling simples
;; - Drag & drop funcional

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org básico e melhorias visuais
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode))
  :config
  (setq org-ellipsis " ▼"
        org-hide-emphasis-markers t
        org-pretty-entities t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ícones bonitos nas bullets (equivalente ao +pretty do Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list
        '("●" "○" "◆" "▶")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-appear (animações para ênfases ao editar)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autosubmarkers t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-tempo (atalhos tipo <s TAB, <python TAB)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org-tempo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-roam (equivalente ao +roam do Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-roam
  :init
  (setq org-roam-directory (expand-file-name "~/org/roam"))
  :config
  (org-roam-db-autosync-mode)
  (setq org-roam-v2-ack t)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n r" . org-roam-buffer-toggle)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Export via Pandoc (equivalente ao +pandoc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ox-pandoc
  :after org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Journaling simples (equivalente ao +journal)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/org-journal-today ()
  "Cria ou abre o arquivo de journal do dia."
  (interactive)
  (let* ((dir "~/org/journal/")
         (file (concat dir (format-time-string "%Y-%m-%d") ".org")))
    (unless (file-directory-p dir)
      (make-directory dir t))
    (find-file file)
    (unless (file-exists-p file)
      (insert (format "#+title: %s\n\n" (format-time-string "%Y-%m-%d"))))))

(global-set-key (kbd "C-c o j") #'leo/org-journal-today)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drag and drop de arquivos (equivalente ao +dragndrop)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-M-RET-may-split-line nil)

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local org-file-apps
                        '((auto-mode . emacs)
                          ("\\.png\\'" . "feh %s")
                          ("\\.jpg\\'" . "feh %s")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Melhorias gerais do Org (parecido com Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-startup-with-inline-images t
      org-image-actual-width '(300))

(provide 'lang-org)
;;; lang-org.el ends here
