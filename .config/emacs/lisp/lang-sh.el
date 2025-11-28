;;; lang-sh.el --- Suporte para Shell Script (Bash/Zsh) -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte para:
;; - bash/sh com treesitter (quando disponível)
;; - LSP via bash-language-server
;; - shfmt via Apheleia
;; - Helpers para executar shell scripts
;; - Atalhos úteis

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter para Shell (quando existir)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs 30+ possui bash-ts-mode
(when (boundp 'bash-ts-mode)
  (add-to-list 'auto-mode-alist '("\\.sh\\'" . bash-ts-mode)))

(add-to-list 'auto-mode-alist '("\\.bash\\'" . sh-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP para Shell via bash-language-server
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((bash-ts-mode sh-mode) .
                 ("bash-language-server" "start"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers: executar scripts shell rapidamente
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/sh-run ()
  "Torna executável e roda o script atual."
  (interactive)
  (when buffer-file-name
    (shell-command (format "chmod +x %s" buffer-file-name))
    (compile buffer-file-name)))

(global-set-key (kbd "C-c s r") #'leo/sh-run)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação básica
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq sh-basic-offset 4)

(provide 'lang-sh)
;;; lang-sh.el ends here
