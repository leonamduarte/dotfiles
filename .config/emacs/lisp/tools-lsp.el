;;; tools-lsp.el --- LSP, Eglot e Tree-sitter -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo equivale ao Doom:
;;   :tools (lsp +eglot)
;;   :tools tree-sitter
;;
;; Fornece:
;; - Eglot como cliente LSP leve e integrado
;; - Tree-sitter para sintaxe moderna
;; - Configs para linguagens fullstack

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tree-sitter — sintaxe moderna
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Core do Tree-sitter
(elpaca (tree-sitter
         :host github
         :repo "emacs-tree-sitter/emacs-tree-sitter")
  (use-package tree-sitter
  :after tree-sitter-langs
  :hook ((prog-mode . tree-sitter-mode)
         (tree-sitter-mode . tree-sitter-hl-mode))))

;; Grammars pré-compiladas (Windows-friendly)
(elpaca (tree-sitter-langs
         :after tree-sitter
         :host github
         :repo "emacs-tree-sitter/tree-sitter-langs"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot — LSP moderno e integrado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (html-mode . eglot-ensure)
         (css-mode . eglot-ensure)
         (json-ts-mode . eglot-ensure)
         (yaml-ts-mode . eglot-ensure)
         (java-ts-mode . eglot-ensure))
  :config
  ;; Melhor documentação
  (setq eglot-events-buffer-size 0)

  ;; Em integração com Apheleia
  (add-to-list 'eglot-server-programs
               '((web-mode html-mode) . ("vscode-html-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Atalhos úteis estilo Doom para LSP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c d") #'eldoc-doc-buffer))

(provide 'tools-lsp)
;;; tools-lsp.el ends here
