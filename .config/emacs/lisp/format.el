
;;; format.el --- Global formatting configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Centraliza formatação: Apheleia + format-on-save e configurações por linguagem.

;;; Code:

(use-package apheleia
  :elpaca (:host github :repo "radian-software/apheleia")
  :init
  ;; Ativa automaticamente em programação
  (add-hook 'prog-mode-hook #'apheleia-mode)

  :config
  (setq apheleia-loggers nil)

  ;;
  ;; -------------------------
  ;; Formatadores (formatters)
  ;; -------------------------
  ;;

  ;; Prettier
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))

  ;; Black (Python)
  (setf (alist-get 'black apheleia-formatters)
        '("black" "-"))

  ;; Isort
  (setf (alist-get 'isort apheleia-formatters)
        '("isort" "--stdout" "-"))

  ;; Python combinado (isort → black)
  (setf (alist-get 'python-format apheleia-formatters)
        '(("isort" "--stdout" filepath)
          ("black" "-")))

  ;; Google Java Format
  (setf (alist-get 'google-java apheleia-formatters)
        '("google-java-format" "-"))

  ;; Shfmt (shell)
  (setf (alist-get 'shfmt apheleia-formatters)
        '("shfmt" "-i" "4" "-"))


  ;;
  ;; -------------------------
  ;; Associação modo → formatador
  ;; -------------------------
  ;;

  ;; Web / TS / JS / JSON
  (dolist (mode '(html-ts-mode css-ts-mode web-mode
                  js-mode js-ts-mode
                  typescript-ts-mode tsx-ts-mode
                  json-mode json-ts-mode
                  yaml-ts-mode))
    (add-to-list 'apheleia-mode-alist `(,mode . prettier)))

  ;; Python
  (add-to-list 'apheleia-mode-alist '(python-mode . python-format))
  (add-to-list 'apheleia-mode-alist '(python-ts-mode . python-format))

  ;; Java
  (add-to-list 'apheleia-mode-alist '(java-ts-mode . google-java))

  ;; Shell
  (add-to-list 'apheleia-mode-alist '(sh-mode . shfmt))
  (add-to-list 'apheleia-mode-alist '(bash-ts-mode . shfmt))
  )

;;
;; Comando manual estilo Doom (SPC c f)
;;
(defun leo/format-buffer ()
  "Format buffer usando Apheleia."
  (interactive)
  (apheleia-format-buffer))

(provide 'format)
;;; format.el ends here

