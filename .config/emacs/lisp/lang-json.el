;;; lang-json.el --- Suporte para JSON moderno -*- lexical-binding: t; -*-
;;; Commentary:
;; - json-ts-mode (treesitter)
;; - LSP via vscode-json-languageserver
;; - Formatação automática com prettier
;; - Atalhos de validação

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON com treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP para JSON
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((json-ts-mode) .
                 ("vscode-json-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prettier via Apheleia
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package apheleia
  :ensure nil
  :config
  (add-to-list 'apheleia-mode-alist '(json-ts-mode . prettier)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper: validar JSON rapidamente
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/json-validate ()
  "Valida o JSON no buffer atual."
  (interactive)
  (when buffer-file-name
    (compile (format "jsonlint %s"
                     (shell-quote-argument buffer-file-name)))))

(global-set-key (kbd "C-c j v") #'leo/json-validate)

(provide 'lang-json)
;;; lang-json.el ends here
