;;; lang-react.el --- Suporte para React, JSX, TSX -*- lexical-binding: t; -*-
;;; Commentary:
;; Fornece suporte moderno para React:
;; - TSX/JSX com tsx-ts-mode (treesitter)
;; - Integração com Eglot (typescript-language-server)
;; - Prettier automático via Apheleia
;; - eslint --fix
;; - Emmet para escrita rápida
;; - Configurações equivalentes ao módulo :lang (javascript +tree-sitter) + React do Doom

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TSX e JSX — Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot para React (TSX/JSX)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  ;; tsserver já suporta React, sem ajuste adicional
  (add-to-list 'eglot-server-programs
               '((tsx-ts-mode) .
                 ("typescript-language-server" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emmet — escrever HTML em JSX/TSX mais rápido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package emmet-mode
;;   :hook ((tsx-ts-mode . emmet-mode)
;;          (web-mode . emmet-mode))
;;   :config
;;   (setq emmet-expand-jsx-className? t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eslint --fix para React
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/eslint-react-fix ()
  "Roda eslint --fix no arquivo atual (React)."
  (interactive)
  (when buffer-file-name
    (compile (format "eslint --fix %s"
                     (shell-quote-argument buffer-file-name)))))

(global-set-key (kbd "C-c r f") #'leo/eslint-react-fix)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Comentários e indentação mais naturais
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq tsx-indent-offset 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pequenas melhorias de produtividade
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/react-component ()
  "Insere template básico de componente React."
  (interactive)
  (insert "export default function Component() {\n  return (\n    <div>\n    </div>\n  );\n}"))

(global-set-key (kbd "C-c r c") #'leo/react-component)

(provide 'lang-react)
;;; lang-react.el ends here
