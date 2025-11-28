
;;; lang-sh.el --- Shell Script / Bash ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - bash-ts-mode
;; - LSP via bash-language-server (local > global)
;; - shfmt via Apheleia já configurado no módulo format
;; - helpers para execução e shellcheck
;; - integrações SPC m s …

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (boundp 'bash-ts-mode)
  (add-to-list 'auto-mode-alist '("\\.sh\\'"   . bash-ts-mode)))
(add-to-list 'auto-mode-alist '("\\.bash\\'"   . sh-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP — bash-language-server com detecção local
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (defun leo/bashls-server ()
    "Retorna bash-language-server local ou global."
    (let* ((proj (project-current))
           (root (and proj (project-root proj)))
           (local (and root (expand-file-name
                             "node_modules/.bin/bash-language-server" root))))
      (if (and local (file-executable-p local))
          (list local "start")
        '("bash-language-server" "start"))))

  (add-to-list 'eglot-server-programs
               '((bash-ts-mode sh-mode) . leo/bashls-server)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Runner — executar shell scripts de forma segura
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/sh-run ()
  "Torna executável e roda o script atual com bash."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não tem arquivo salvo."))

  (let ((cmd (format "bash %s"
                     (shell-quote-argument buffer-file-name))))
    (compile cmd)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ShellCheck — lint inteligente
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/sh-shellcheck-binary ()
  "Detecta shellcheck no projeto ou no sistema."
  (let* ((proj (project-current))
         (root (and proj (project-root proj)))
         (local (and root
                     (expand-file-name "node_modules/.bin/shellcheck" root))))
    (cond
     ((and local (file-executable-p local)) local)
     ((executable-find "shellcheck"))
     (t nil))))

(defun leo/sh-lint ()
  "Roda shellcheck no script atual."
  (interactive)
  (unless buffer-file-name
    (user-error "Buffer sem arquivo associado."))

  (let ((bin (leo/sh-shellcheck-binary)))
    (unless bin
      (user-error "shellcheck não encontrado localmente nem no PATH."))
    (compile (format "%s %s"
                     bin
                     (shell-quote-argument buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-style leader bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-prefix-command 'leo/leader-sh-map)
  (define-key leo/leader-map (kbd "m s") 'leo/leader-sh-map)

  (define-key leo/leader-sh-map (kbd "r") #'leo/sh-run)
  (define-key leo/leader-sh-map (kbd "l") #'leo/sh-lint))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq sh-basic-offset 4
      sh-indentation 4)

(provide 'lang-sh)
;;; lang-sh.el ends here
