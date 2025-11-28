;;; early-init.el --- Load antes do init.el -*- lexical-binding: t; -*-
;;; Commentary:
;; Desativa o package.el antes de carregar qualquer coisa
;;; Code:
(setq package-quickstart nil)

;; Opcional: evita que o Emacs carregue interface antes do UI.el
(setq inhibit-startup-screen t)
(setq inhibit-default-init t)
(setq frame-resize-pixelwise t)

(provide 'early-init)
;;; early-init.el ends here
