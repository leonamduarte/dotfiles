;;; lang-yaml.el --- Suporte para YAML moderno -*- lexical-binding: t; -*-
;;; Commentary:
;; - yaml-ts-mode com treesitter
;; - LSP via yaml-language-server
;; - Apheleia (prettier)
;; - Atalho de validação

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YAML com treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP para YAML
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((yaml-ts-mode) .
                 ("yaml-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper: validar YAML
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/yaml-validate ()
  "Valida YAML usando yamllint."
  (interactive)
  (when buffer-file-name
    (compile (format "yamllint %s"
                     (shell-quote-argument buffer-file-name)))))

(global-set-key (kbd "C-c y v") #'leo/yaml-validate)

(provide 'lang-yaml)
;;; lang-yaml.el ends here
