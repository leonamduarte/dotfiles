;;; lang-python.el --- Suporte avançado para Python -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte completo para Python com:
;; - python-ts-mode (treesitter)
;; - LSP via pyright (Eglot)
;; - Formatação com black + isort
;; - Execução de scripts e virtualenv helpers
;; - Comportamento equivalente ao módulo Doom Python

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python com Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot: LSP com Pyright
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("pyright-langserver" "--stdio"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Formatação com black + isort via Apheleia
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package apheleia
  :ensure nil
  :config
  ;; Define formatadores
  (setf (alist-get 'black apheleia-formatters)
        '("black" "-"))
  (setf (alist-get 'isort apheleia-formatters)
        '("isort" "--stdout" "-"))

  ;; Combine black + isort
  (setf (alist-get 'python-format apheleia-formatters)
        '(("isort" "--stdout" filepath)
          ("black" "-")))

  ;; Usa no python-ts-mode
  (add-to-list 'apheleia-mode-alist
               '(python-ts-mode . python-format)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers para execução de scripts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/python-run ()
  "Roda o arquivo Python atual."
  (interactive)
  (when buffer-file-name
    (compile (format "python3 %s"
                     (shell-quote-argument buffer-file-name)))))

(global-set-key (kbd "C-c p r") #'leo/python-run)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REPL simples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/python-repl ()
  "Abre um REPL interativo Python."
  (interactive)
  (run-python))

(global-set-key (kbd "C-c p i") #'leo/python-repl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Virtualenv minimalista
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar leo/python-venv nil
  "Caminho da virtualenv ativa.")

(defun leo/python-activate-venv ()
  "Ativa uma virtualenv manualmente."
  (interactive)
  (let ((path (read-directory-name "Virtualenv: ")))
    (setq leo/python-venv path)
    (setenv "VIRTUAL_ENV" path)
    (setenv "PATH" (concat path "/bin:" (getenv "PATH")))
    (message "Venv ativa: %s" path)))

(global-set-key (kbd "C-c p v") #'leo/python-activate-venv)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação e estilo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq python-indent-offset 4)

(provide 'lang-python)
;;; lang-python.el ends here
