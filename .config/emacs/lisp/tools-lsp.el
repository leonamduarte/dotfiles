
;;; tools-lsp.el --- LSP unificado (Eglot) + Tree-sitter moderno -*- lexical-binding: t; -*-
;;; Commentary:
;; - Usa só treesit-auto (Emacs 29+)
;; - Eglot leve e universal
;; - Hooks corretos para modos tree-sitter
;; - Integração Doom-like com leader keys

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tree-sitter com treesit-auto (já declarado em packages.el)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Nada aqui: toda configuração de tree-sitter é centralizada em packages.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot — cliente LSP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  ;; Ativa em todos os modos modernos
  :hook ((python-ts-mode     . eglot-ensure)
         (js-ts-mode         . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode        . eglot-ensure)
         (html-ts-mode       . eglot-ensure)
         (css-ts-mode        . eglot-ensure)
         (json-ts-mode       . eglot-ensure)
         (yaml-ts-mode       . eglot-ensure)
         (java-ts-mode       . eglot-ensure))
  :config
  ;; melhora logs/silencia interno
  (setq eglot-events-buffer-size 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-style LSP leader keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-key leo/leader-lsp-map (kbd "r") #'eglot-rename)
  (define-key leo/leader-lsp-map (kbd "a") #'eglot-code-actions)
  (define-key leo/leader-lsp-map (kbd "f") #'eglot-format)
  (define-key leo/leader-lsp-map (kbd "d") #'eldoc-doc-buffer))

(provide 'tools-lsp)
;;; tools-lsp.el ends here
