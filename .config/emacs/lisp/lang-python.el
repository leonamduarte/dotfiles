
;;; lang-python.el --- Python ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - python-ts-mode
;; - Pyright com fallback local
;; - REPL integrado
;; - Runner confiável
;; - Venv seguro (pyvenv)
;; - Helpers para pytest e requirements
;; - Atalhos SPC m p …

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python com Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot + Pyright (com detecção de binário local)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (defun leo/pyright-server ()
    "Retorna pyright local ou global."
    (let* ((proj (project-current))
           (root (and proj (project-root proj)))
           (local (and root (expand-file-name
                             "node_modules/.bin/pyright-langserver"
                             root))))
      (if (and local (file-executable-p local))
          (list local "--stdio")
        '("pyright-langserver" "--stdio"))))

  (add-to-list 'eglot-server-programs
               '(python-ts-mode . leo/pyright-server)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Execução de scripts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/python-run ()
  "Roda o arquivo Python atual no terminal."
  (interactive)
  (unless buffer-file-name
    (user-error "Buffer não está associado a um arquivo."))

  (let* ((cmd (cond ((executable-find "python3") "python3")
                    ((executable-find "python") "python")
                    (t (error "Nenhum Python encontrado no PATH")))))
    (compile (format "%s %s"
                     cmd
                     (shell-quote-argument buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REPL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/python-repl ()
  "Abre um REPL Python no ambiente ativo."
  (interactive)
  (let ((python-shell-interpreter
         (or (and leo/python-venv
                  (expand-file-name "bin/python" leo/python-venv))
             (or (executable-find "python3")
                 (executable-find "python")))))
    (run-python)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Virtualenv com pyvenv (como Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pyvenv
  :commands (pyvenv-activate pyvenv-deactivate)
  :config
  (setq pyvenv-workon "default"))

(defun leo/python-activate-venv ()
  "Ativa uma virtualenv via pyvenv."
  (interactive)
  (let ((path (read-directory-name "Venv: ")))
    (pyvenv-activate path)
    (setq leo/python-venv path)
    (message "Venv ativada: %s" path)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers adicionais úteis (Doom-like)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/python-install-requirements ()
  "Instala requirements.txt no projeto atual."
  (interactive)
  (let* ((root (or (and (project-current) (project-root (project-current)))
                   default-directory))
         (req (expand-file-name "requirements.txt" root)))
    (unless (file-exists-p req)
      (user-error "Nenhum requirements.txt encontrado"))
    (compile (format "pip install -r %s" (shell-quote-argument req)))))

(defun leo/python-pytest ()
  "Roda pytest no projeto."
  (interactive)
  (let ((root (or (and (project-current) (project-root (project-current)))
                  default-directory)))
    (compile (format "pytest %s" root))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-style leader bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-prefix-command 'leo/leader-python-map)
  (define-key leo/leader-map (kbd "m p") 'leo/leader-python-map)

  (define-key leo/leader-python-map (kbd "r") #'leo/python-run)
  (define-key leo/leader-python-map (kbd "i") #'leo/python-repl)
  (define-key leo/leader-python-map (kbd "v") #'leo/python-activate-venv)
  (define-key leo/leader-python-map (kbd "t") #'leo/python-pytest)
  (define-key leo/leader-python-map (kbd "R") #'leo/python-install-requirements))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq python-indent-offset 4)

(provide 'lang-python)
;;; lang-python.el ends here
