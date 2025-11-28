
;;; init.el --- Inicialização completa -*- lexical-binding: t; -*-
;;; Commentary:
;; Inicialização simples, sólida e modular usando straight.el + use-package.
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1) Bootstrap do straight.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq straight-use-package-by-default t)

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; use-package via straight
(straight-use-package 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2) Carregar pasta lisp/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3) Carregar módulos (após straight)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun leo/load (feature)
  "Carrega um módulo e registra erro sem travar o Emacs."
  (condition-case err
      (require feature)
    (error
     (message "⚠️ Falha ao carregar %s: %s" feature (error-message-string err)))))

(mapc #'leo/load
      '(packages core ui editor completion editor-evil
        tools-lsp tools-project
        lang-javascript lang-react lang-python lang-java
        lang-html-css lang-json lang-yaml lang-sh lang-org
        bindings ui-dashboard extras files format tools-git))

; (require 'packages)
; (require 'core)
; (require 'ui)
; (require 'editor)
; (require 'completion)
; (require 'editor-evil)
; (require 'tools-lsp)
; (require 'tools-project)
; (require 'lang-javascript)
; (require 'lang-react)
; (require 'lang-python)
; (require 'lang-java)
; (require 'lang-html-css)
; (require 'lang-json)
; (require 'lang-yaml)
; (require 'lang-sh)
; (require 'lang-org)
; (require 'bindings)
; (require 'ui-dashboard)
; (require 'extras)
; (require 'files)
; (require 'format)
; (require 'tools-git)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4) Finalização
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'init)
;;; init.el ends here
