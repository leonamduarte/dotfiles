
;;; lang-json.el --- JSON / JSONC moderno ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - json-ts-mode (treesitter)
;; - JSON, JSONC (VSCode style)
;; - LSP via vscode-json-language-server
;; - Prettier via Apheleia (format.el)
;; - Validação segura
;; - Integração com leader key: SPC m j …

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON + JSONC com Tree-sitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.json\\'"   . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsonc\\'"  . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json5\\'"  . json-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot — JSON LSP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((json-ts-mode json-mode)
                 . ("vscode-json-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON Validate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/jsonlint-binary ()
  "Detecta jsonlint — local ou global."
  (let* ((root (when (project-current)
                 (project-root (project-current))))
         (local-bin (when root
                      (expand-file-name "node_modules/.bin/jsonlint" root))))
    (cond
     ((and local-bin (file-executable-p local-bin)) local-bin)
     ((executable-find "jsonlint"))
     (t nil))))

(defun leo/json-validate ()
  "Valida o JSON atual usando jsonlint quando disponível."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não possui arquivo salvo."))

  (let ((jsonlint (leo/jsonlint-binary)))
    (unless jsonlint
      (user-error "jsonlint não encontrado em node_modules/.bin nem no PATH."))

    (compile (format "%s %s"
                     jsonlint
                     (shell-quote-argument buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-like leader key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-prefix-command 'leo/leader-json-map)
  (define-key leo/leader-map (kbd "m J") 'leo/leader-json-map)

  (define-key leo/leader-json-map (kbd "v") #'leo/json-validate))

(provide 'lang-json)
;;; lang-json.el ends here
