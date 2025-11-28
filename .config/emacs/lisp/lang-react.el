
;;; lang-react.el --- React / JSX / TSX ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - TSX/JSX com treesitter
;; - LSP unificado (via lang-javascript)
;; - eslint --fix com detecção local
;; - Emmet para JSX
;; - templates úteis
;; - integrações SPC m r …

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TSX / JSX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))

;; Indentação correta para JSX
(setq js-jsx-indent-level 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emmet (HTML → JSX turbo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emmet-mode
  :hook ((tsx-ts-mode . emmet-mode)
         (js-ts-mode  . emmet-mode)
         (web-mode    . emmet-mode))
  :config
  (setq emmet-expand-jsx-className? t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eslint --fix (React-friendly)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/eslint-react-binary ()
  "Retorna eslint local ou global."
  (let* ((proj (project-current))
         (root (and proj (project-root proj)))
         (local (and root (expand-file-name "node_modules/.bin/eslint" root))))
    (cond
     ((and local (file-executable-p local)) local)
     ((executable-find "eslint"))
     (t nil)))

(defun leo/eslint-react-fix ()
  "Roda eslint --fix no arquivo atual."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não tem arquivo salvo."))

  (let ((eslint (leo/eslint-react-binary)))
    (unless eslint
      (user-error "eslint não encontrado no projeto nem no sistema."))

    (compile (format "%s --fix %s"
                     eslint
                     (shell-quote-argument buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Snippets: componente React básico
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/react-component ()
  "Insere template básico de componente React."
  (interactive)
  (insert "export default function Component() {\n  return (\n    <div>\n    </div>\n  );\n}"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-style leader bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-prefix-command 'leo/leader-react-map)
  (define-key leo/leader-map (kbd "m r") 'leo/leader-react-map)

  (define-key leo/leader-react-map (kbd "f") #'leo/eslint-react-fix)
  (define-key leo/leader-react-map (kbd "c") #'leo/react-component))

(provide 'lang-react)
;;; lang-react.el ends here
