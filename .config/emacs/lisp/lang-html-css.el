;;; lang-html-css.el --- Suporte para HTML, CSS e Web -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo fornece suporte completo para desenvolvimento web:
;; - HTML e CSS com treesitter
;; - web-mode para arquivos mistos (templates, JSX-like)
;; - Emmet para expansão rápida
;; - Prettier automático via Apheleia
;; - LSP via vscode-html-language-server e vscode-css-language-server
;; - Integração com React/JS/TS
;;
;; Equivalente ao Doom :lang web +lsp +tree-sitter

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML e CSS com Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.html?\\'" . html-ts-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; web-mode para arquivos mistos (Vue, Svelte, templates, etc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package web-mode
  :mode ("\\.html?\\'"
         "\\.css\\'"
         "\\.jsx\\'"
         "\\.tsx\\'"
         "\\.php\\'"
         "\\.jsp\\'"
         "\\.vue\\'"
         "\\.svelte\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-enable-auto-quoting nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emmet — HTML turbo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emmet-mode
  :hook ((html-ts-mode . emmet-mode)
         (css-ts-mode . emmet-mode)
         (web-mode . emmet-mode)
         (tsx-ts-mode . emmet-mode)
         (web-mode . emmet-mode))
  :config
  (setq emmet-expand-jsx-className? t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP: HTML e CSS (via Eglot)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  ;; HTML LSP
  (add-to-list 'eglot-server-programs
               '((html-ts-mode web-mode) .
                 ("vscode-html-language-server" "--stdio")))

  ;; CSS LSP
  (add-to-list 'eglot-server-programs
               '((css-ts-mode web-mode) .
                 ("vscode-css-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Atalhos úteis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/html-preview ()
  "Abre o arquivo HTML atual no navegador padrão."
  (interactive)
  (when buffer-file-name
    (browse-url-of-file buffer-file-name)))

(global-set-key (kbd "C-c h p") #'leo/html-preview)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação e comportamento
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq css-indent-offset 2)

(provide 'lang-html-css)
;;; lang-html-css.el ends here
