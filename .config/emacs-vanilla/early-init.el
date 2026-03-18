;;; early-init.el --- Vanilla Emacs early startup -*- lexical-binding: t; -*-

;; Layer 0: keep startup predictable and prevent package.el from activating.
(setq package-enable-at-startup nil
      package-quickstart nil
      gc-cons-threshold most-positive-fixnum
      frame-inhibit-implied-resize t)

;; Minimal UI cleanup before the first frame is shown.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;;; early-init.el ends here
