
;;; lang-yaml.el --- YAML moderno ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - yaml-ts-mode
;; - LSP via yaml-language-server (local > global)
;; - lint via yamllint
;; - integração SPC m y …

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YAML + Tree-sitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode))

;; Indentação mais confiável (VSCode-like)
(setq yaml-indent-offset 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP — yaml-language-server com detecção local
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (defun leo/yamlls-server ()
    "Detecta yaml-language-server local ou global."
    (let* ((proj (project-current))
           (root (and proj (project-root proj)))
           (local (and root
                       (expand-file-name
                        "node_modules/.bin/yaml-language-server" root))))
      (if (and local (file-executable-p local))
          (list local "--stdio")
        '("yaml-language-server" "--stdio"))))

  (add-to-list 'eglot-server-programs
               '((yaml-ts-mode yaml-mode) . leo/yamlls-server)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Linter — yamllint (VSCode-like)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/yamllint-binary ()
  "Detecta yamllint local ou global."
  (let* ((proj (project-current))
         (root (and proj (project-root proj)))
         (local (and root
                     (expand-file-name "node_modules/.bin/yamllint" root))))
    (cond
     ((and local (file-executable-p local)) local)
     ((executable-find "yamllint"))
     (t nil))))

(defun leo/yaml-validate ()
  "Valida YAML usando yamllint."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não possui arquivo salvo."))

  (let ((bin (leo/yamllint-binary)))
    (unless bin
      (user-error "yamllint não encontrado localmente nem no sistema."))
    (compile (format "%s %s"
                     bin
                     (shell-quote-argument buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-style leader bindings (SPC m y …)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-prefix-command 'leo/leader-yaml-map)
  (define-key leo/leader-map (kbd "m y") 'leo/leader-yaml-map)

  (define-key leo/leader-yaml-map (kbd "v") #'leo/yaml-validate))

(provide 'lang-yaml)
;;; lang-yaml.el ends here
