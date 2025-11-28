;;; lang-javascript.el --- JavaScript / TypeScript / Node -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte completo para:
;; - JavaScript moderno (JS)
;; - TypeScript (TS)
;; - Node.js e Express
;; - Integração com Eglot
;; - Treesitter
;; - Formatação com Prettier (via Apheleia)
;; - TSX/JSX quando usado com React (config separado no módulo React)

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS e TS com Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; js-ts-mode e tsx-ts-mode já são fornecidos nas versões modernas do Emacs.
;; typescript-ts-mode também.

(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'" . js-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot: LSP para JS/TS/Node
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((js-ts-mode typescript-ts-mode) .
                 ("typescript-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prettier via Apheleia (igual ao format +onsave do Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package apheleia
  :ensure nil  ;; já foi carregado no editor.el
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))

  (dolist (mode '(js-ts-mode typescript-ts-mode))
    (add-to-list 'apheleia-mode-alist `(,mode . prettier))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Node helpers (Express + Route debugging)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/node-run ()
  "Executa 'node .' na raiz do projeto."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (compile "node .")))

(defun leo/node-npm-start ()
  "Executa 'npm start' no projeto."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (compile "npm start")))

(global-set-key (kbd "C-c n r") #'leo/node-run)
(global-set-key (kbd "C-c n s") #'leo/node-npm-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Comentário e indentação estilo VSCode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq js-indent-level 2
      typescript-indent-level 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Integrar eslint caso exista no projeto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/eslint-fix ()
  "Roda eslint '--fix' no arquivo atual."
  (interactive)
  (when buffer-file-name
    (compile (format "eslint --fix %s" (shell-quote-argument buffer-file-name)))))

(global-set-key (kbd "C-c n f") #'leo/eslint-fix)

(provide 'lang-javascript)
;;; lang-javascript.el ends here
