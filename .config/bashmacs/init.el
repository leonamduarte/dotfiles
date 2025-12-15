;;; init.el --- Bootstrap simples com package.el -*- lexical-binding: t -*-
;;; Code:

;; =========================================================
;; Codificação (importante no Windows)
;; =========================================================

(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-language-environment "UTF-8")

;; =========================================================
;; Package.el — gerenciador nativo
;; =========================================================

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("melpa"  . "https://melpa.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; =========================================================
;; use-package — organização do config
;; =========================================================

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t
      use-package-always-defer nil
      use-package-expand-minimally t)

;; =========================================================
;; Comportamentos básicos (core)
;; =========================================================

(use-package emacs
  :ensure nil
  :config
  (setq ring-bell-function #'ignore))

;; =========================================================
;; Garbage Collector — simples e seguro
;; =========================================================

(setq gc-cons-threshold (* 50 1024 1024))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1024 1024))))

;; =========================================================
;; Carrega configuração principal
;; =========================================================

(load (expand-file-name "config.el" user-emacs-directory))

;; =========================================================
;; Fim
;; =========================================================

(provide 'init)
;;; init.el ends here
