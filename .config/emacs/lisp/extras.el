
;;; extras.el --- Utilidades extras e QoL ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Funções avulsas de qualidade de vida:
;; - sudo-edit
;; - terminal
;; - pomodoro
;; - navegação
;; - limpeza de buffers
;; - QoL geral

;;; Code:

;; ---------------------------------------------------------------------------
;; Arquivos grandes
;; ---------------------------------------------------------------------------

(setq large-file-warning-threshold (* 50 1024 1024))

;; ---------------------------------------------------------------------------
;; Sudo-edit seguro
;; ---------------------------------------------------------------------------

(defun leo/sudo-edit (&optional arg)
  "Editar arquivo atual ou outro arquivo como root."
  (interactive "P")
  (let ((fname (if arg
                   (read-file-name "Arquivo como root: ")
                 buffer-file-name)))
    (find-file (format "/sudo:root@localhost:%s" fname))))
(global-set-key (kbd "C-c x s") #'leo/sudo-edit)

;; ---------------------------------------------------------------------------
;; Restart do Emacs (via restart-emacs, igual Doom)
;; ---------------------------------------------------------------------------

(use-package restart-emacs
  :commands restart-emacs)

;; ---------------------------------------------------------------------------
;; Terminal integrado com fallback
;; ---------------------------------------------------------------------------

(defun leo/terminal-here ()
  "Abre vterm ou shell nativo no diretório atual."
  (interactive)
  (let ((default-directory (or default-directory "~")))
    (cond
     ((fboundp 'vterm)
      (require 'vterm)
      (vterm (generate-new-buffer-name "*vterm*")))
     (t
      (shell (generate-new-buffer-name "*shell*"))))))
(global-set-key (kbd "C-c x t") #'leo/terminal-here)

;; ---------------------------------------------------------------------------
;; Pomodoro simples com cancelamento
;; ---------------------------------------------------------------------------

(defvar leo/pomodoro-timer nil
  "Timer atual do Pomodoro.")

(defun leo/pomodoro-start ()
  (interactive)
  (when leo/pomodoro-timer
    (cancel-timer leo/pomodoro-timer))
  (setq leo/pomodoro-timer
        (run-at-time
         "25 min" nil
         (lambda ()
           (setq leo/pomodoro-timer nil)
           (message "🍅 Pomodoro terminado, Leo!")))))
(global-set-key (kbd "C-c x p") #'leo/pomodoro-start)

(defun leo/pomodoro-cancel ()
  (interactive)
  (when leo/pomodoro-timer
    (cancel-timer leo/pomodoro-timer)
    (setq leo/pomodoro-timer nil)
    (message "⏹ Pomodoro cancelado.")))
(global-set-key (kbd "C-c x P") #'leo/pomodoro-cancel)

;; ---------------------------------------------------------------------------
;; Abrir pasta da config
;; ---------------------------------------------------------------------------

(defun leo/open-config ()
  (interactive)
  (dired (expand-file-name "lisp" user-emacs-directory)))
(global-set-key (kbd "C-c x c") #'leo/open-config)

;; ---------------------------------------------------------------------------
;; Navegação e edição geral
;; ---------------------------------------------------------------------------

(global-subword-mode 1)

;; Matando buffers de compilação
(defun leo/clear-compilation ()
  (interactive)
  (dolist (buf (buffer-list))
    (when (string-match-p "\\*compilation\\*" (buffer-name buf))
      (kill-buffer buf)))
  (message "🧹 Buffers de compilação limpos."))
(global-set-key (kbd "C-c x k") #'leo/clear-compilation)

;; ---------------------------------------------------------------------------
;; Silêncio e confirmações
;; ---------------------------------------------------------------------------

(setq ring-bell-function #'ignore)
(setq confirm-kill-processes nil)
(setq select-enable-clipboard t)

(provide 'extras)
;;; extras.el ends here
