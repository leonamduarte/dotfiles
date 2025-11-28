;;; extras.el --- Utilidades extras e melhorias gerais -*- lexical-binding: t; -*-
;;; Commentary:
;; Funções avulsas, helpers, QoL, ajustes de comportamento e extensões
;; que não pertencem a um módulo específico.

;;; Code:

;; Arquivos grandes: evitar travamentos
(setq large-file-warning-threshold (* 50 1024 1024))

;; sudo-edit seguro
(defun leo/sudo-edit (&optional arg)
  "Editar arquivo atual ou outro arquivo como root."
  (interactive "P")
  (let ((fname (if arg
                   (read-file-name "Arquivo root: ")
                 buffer-file-name)))
    (find-file (format "/sudo:root@localhost:%s" fname))))
(global-set-key (kbd "C-c x s") #'leo/sudo-edit)

;; NÃO use whitespace-cleanup sempre — ws-butler já faz isso
;; (removido o hook)

;; Restart do Emacs
(defun restart-emacs ()
  "Reinicia o Emacs rapidamente."
  (interactive)
  (save-some-buffers t)
  (call-process "emacs" nil 0 nil)
  (kill-emacs))

;; Navegação de janelas
(use-package windmove
  :ensure nil
  :config
  (windmove-default-keybindings))

;; Terminal integrado
(defun leo/terminal-here ()
  "Abre vterm no diretório atual."
  (interactive)
  (require 'vterm)
  (vterm (generate-new-buffer-name "*vterm*")))
(global-set-key (kbd "C-c x t") #'leo/terminal-here)

;; Pomodoro simples
(defun leo/pomodoro-start ()
  (interactive)
  (run-at-time
   "25 min" nil
   (lambda () (message "🍅 Pomodoro terminado, Leo!"))))
(global-set-key (kbd "C-c x p") #'leo/pomodoro-start)

(setq select-enable-clipboard t)

(defun leo/open-config ()
  (interactive)
  (dired "~/.emacs.d/lisp"))
(global-set-key (kbd "C-c x c") #'leo/open-config)

(global-subword-mode 1)

(defun leo/clear-compilation ()
  (interactive)
  (dolist (buf (buffer-list))
    (when (string-match-p "\\*compilation\\*" (buffer-name buf))
      (kill-buffer buf)))
  (message "🧹 Buffers de compilação limpos."))
(global-set-key (kbd "C-c x k") #'leo/clear-compilation)

(setq ring-bell-function #'ignore)
(setq confirm-kill-processes nil)

(provide 'extras)
;;; extras.el ends here
