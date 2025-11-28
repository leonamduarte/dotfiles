;;; early-init.el --- Load antes do init.el -*- lexical-binding: t; -*-
;;; Commentary:
;; Desativa o package.el antes de carregar qualquer coisa
;;; Code:
;; Impede o Emacs de inicializar o package.el
(setq package-enable-at-startup nil)
(setq package-quickstart nil)

;; Acelera o startup desativando handlers e aumentando GC
(setq gc-cons-threshold most-positive-fixnum)
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Interface mínima no carregamento (Doom style)
(setq inhibit-startup-screen t
      inhibit-default-init t
      frame-resize-pixelwise t)

;; Remove UI pesada no boot (será reativado no seu ui.el se quiser)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Restaura o GC depois do boot
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216
                  file-name-handler-alist file-name-handler-alist-original)))

(provide 'early-init)
;;; early-init.el ends here
