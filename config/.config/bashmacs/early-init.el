;;; early-init.el --- Otimizações pré-carregamento -*- lexical-binding: t; -*-
;;; Code:

;; =========================================================
;; Garbage Collection — máximo desempenho no startup
;; =========================================================

;; Evita GC durante o boot
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; =========================================================
;; UI — limpa antes da janela aparecer (sem flicker)
;; =========================================================

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; Evita resize automático durante init
(setq frame-inhibit-implied-resize t)

;; =========================================================
;; Codificação
;; =========================================================

(set-language-environment "UTF-8")

;; =========================================================
;; Nota importante:
;; NÃO desabilitamos package.el aqui.
;; Ele será inicializado corretamente no init.el.
;; =========================================================

(provide 'early-init)
;;; early-init.el ends here
