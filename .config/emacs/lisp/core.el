;;; core.el --- Núcleo do Emacs modular -*- lexical-binding: t; -*-

;;; Commentary:
;; Este arquivo define otimizações, comportamento base e ajustes globais.
;; O sistema de pacotes (Elpaca) é inicializado no init.el — portanto,
;; nada aqui deve chamar package.el ou instalar pacotes.

;;; Code:

;; ===================================================================
;; Desempenho
;; ===================================================================

;; Aumenta limites de GC para acelerar inicialização
(setq gc-cons-threshold (* 64 1024 1024))
(setq read-process-output-max (* 4 1024 1024))

;; Evita telas iniciais do Emacs
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

;; Prefira arquivos mais novos (útil para byte-compile)
(setq load-prefer-newer t)

;; ===================================================================
;; Caminho base dos módulos
;; ===================================================================

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ===================================================================
;; Comportamento básico
;; ===================================================================

;; Respostas rápidas
(fset 'yes-or-no-p 'y-or-n-p)

;; Backups em uma pasta dedicada
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

(setq auto-save-default t)

;; ===================================================================

(provide 'core)
;;; core.el ends here
