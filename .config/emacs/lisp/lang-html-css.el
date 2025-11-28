
;;; lang-html-css.el --- Suporte Web ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte completo para desenvolvimento web moderno:
;; - HTML/CSS com tree-sitter
;; - web-mode para templates avançados (Vue, Svelte, PHP, Blade, etc)
;; - Emmet completo
;; - Integração com Eglot (HTML/CSS LS)
;; - Preview rápido
;; - Indentação consistente

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML/CSS com Tree-sitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.html?\\'" . html-ts-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'"   . css-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; web-mode — apenas para arquivos realmente híbridos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package web-mode
:mode ("\\.php\\'"
       "\\.jsp\\'"
       "\\.vue\\'"
       "\\.svelte\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset   2
        web-mode-css-indent-offset    2
        web-mode-enable-auto-quoting nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emmet (HTML turbo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emmet-mode
  :hook ((html-ts-mode . emmet-mode)
         (css-ts-mode  . emmet-mode)
         (web-mode     . emmet-mode))
  :config
  (setq emmet-expand-jsx-className? t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot — LSP HTML/CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  ;; HTML
  (add-to-list 'eglot-server-programs
               '((html-mode html-ts-mode web-mode)
                 "vscode-html-language-server" "--stdio"))

  ;; CSS
  (add-to-list 'eglot-server-programs
               '((css-mode css-ts-mode web-mode)
                 "vscode-css-language-server" "--stdio")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML Preview
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/html-preview ()
  "Abre o arquivo HTML atual no navegador padrão."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não possui arquivo associado."))
  (browse-url-of-file buffer-file-name))

(global-set-key (kbd "C-c h p") #'leo/html-preview)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq css-indent-offset 2)

(provide 'lang-html-css)
;;; lang-html-css.el ends here
