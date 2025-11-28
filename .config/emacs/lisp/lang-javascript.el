
;;; lang-javascript.el --- JavaScript / TypeScript / Node (Doom-like) -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte completo JS/TS/Node:
;; - js-ts-mode, typescript-ts-mode, tsx-ts-mode
;; - Eglot LSP: typescript-language-server
;; - Node/NPM helpers
;; - eslint --fix
;; - Indentação moderna
;; - Hot reload para React no módulo React

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter modos JS/TS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.js\\'"   . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'"  . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'"  . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'"   . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'"  . tsx-ts-mode)) ;; crucial!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot + typescript-language-server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  ;; Procura binário local em node_modules/.bin se existir
  (defun leo/tss-server ()
    (let* ((root (when (project-current)
                   (project-root (project-current))))
           (local-bin (when root
                        (expand-file-name "node_modules/.bin/typescript-language-server"
                                          root))))
      (if (and local-bin (file-executable-p local-bin))
          (list local-bin "--stdio")
        '("typescript-language-server" "--stdio"))))

  ;; Associar todos os modos relevantes
  (add-to-list 'eglot-server-programs
               '((js-ts-mode
                  js-mode
                  typescript-ts-mode
                  tsx-ts-mode
                  tsx-mode)
                 . leo/tss-server)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers de Node
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-root-or-default ()
  "Retorna project root ou diretório atual como fallback."
  (or (and (project-current)
           (project-root (project-current)))
      default-directory))

(defun leo/node-run ()
  "Executa 'node .' no root do projeto."
  (interactive)
  (let ((default-directory (leo/project-root-or-default)))
    (compile "node .")))

(defun leo/node-npm-start ()
  "Executa 'npm start'."
  (interactive)
  (let ((default-directory (leo/project-root-or-default)))
    (compile "npm start")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ESLint Fix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/eslint-fix ()
  "Executa eslint --fix no arquivo atual, se eslint existir."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não tem arquivo associado."))

  (let* ((root (leo/project-root-or-default))
         (eslint-local (expand-file-name "node_modules/.bin/eslint" root))
         (eslint (cond
                  ((file-executable-p eslint-local) eslint-local)
                  ((executable-find "eslint"))
                  (t (user-error "eslint não encontrado no sistema nem no projeto.")))))
    (compile (format "%s --fix %s"
                     eslint
                     (shell-quote-argument buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-like leader key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-prefix-command 'leo/leader-js-map)
  (define-key leo/leader-map (kbd "m j") 'leo/leader-js-map) ;; prefixo: SPC m j

  (define-key leo/leader-js-map (kbd "r") #'leo/node-run)
  (define-key leo/leader-js-map (kbd "s") #'leo/node-npm-start)
  (define-key leo/leader-js-map (kbd "f") #'leo/eslint-fix))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação moderna
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq js-indent-level 2
      typescript-indent-level 2)

(provide 'lang-javascript)
;;; lang-javascript.el ends here
