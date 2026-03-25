;;; packages.el -*- no-byte-compile: t; lexical-binding: t; -*-

;; --- TEMAS ---
(package! catppuccin-theme)
(package! kaolin-themes)

;; --- AI ---
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; --- ORG MODE ---
;; 'toc-org' e 'org-superstar' já vêm com o módulo :lang org +pretty.
;; Mantive apenas o que é extra:
(package! org-auto-tangle)
(package! org-super-agenda)
(package! org-modern) ;; Você usou configurações dele no config.el

;; --- DEV & TOOLS ---
(package! treesit-auto)
(package! harpoon)

(package! grease
  :recipe (:local-repo "lisp/grease"))
  ;; :recipe (:host github :repo "mwac-dev/grease.el"  :files ("*.el")))

;; (package! gcmh)
(package! kdl-mode)
(package! consult-lsp)

;; NOTAS SOBRE REMOÇÕES:
;; - vertico, orderless, consult, embark, marginalia: Removidos pois o módulo :completion vertico já instala.
;; - corfu, corfu-terminal: Removidos pois o módulo :completion corfu já instala.
;; - js2-mode: Removido pois o módulo :lang javascript já traz suporte adequado (e treesitter é o futuro).
;; - org-bullets: Obsoleto, o Doom usa org-superstar nativamente.
