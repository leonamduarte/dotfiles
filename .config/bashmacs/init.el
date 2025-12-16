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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(apheleia cape consult-projectile copilot corfu dashboard
	      doom-modeline doom-themes embark-consult evil-collection
	      general hl-todo js2-mode json-mode lsp-java lsp-ui
	      lua-mode magit marginalia nerd-icons-corfu no-littering
	      nodejs-repl orderless org-auto-tangle org-modern
	      treemacs-evil treesit-auto tsx-ts-mode typescript-mode
	      vertico web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-checkbox ((t (:height 1.2))))
 '(org-document-title ((t (:height 1.5 :weight bold))))
 '(outline-1 ((t (:foreground "#51afef" :weight bold :height 1.3))))
 '(outline-2 ((t (:foreground "#c678dd" :weight bold :height 1.2))))
 '(outline-3 ((t (:foreground "#98be65" :weight bold :height 1.15))))
 '(outline-4 ((t (:foreground "#da8548" :weight bold :height 1.1))))
 '(outline-5 ((t (:foreground "#5699af"))))
 '(outline-6 ((t (:foreground "#46d9ff"))))
 '(outline-7 ((t (:foreground "#a9a1e1"))))
 '(outline-8 ((t (:foreground "#ecbe7b")))))
