;;; packages.el -*- no-byte-compile: t; lexical-binding: t; -*-

;; --- TEMAS ---
(package! catppuccin-theme)
(package! kaolin-themes)

;; --- AI ---
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; --- ORG MODE ---
;; 'toc-org' e 'org-superstar' ja vem com o modulo :lang org +pretty.
;; Mantive apenas o que e extra:
(package! org-auto-tangle)
(package! org-super-agenda)
(package! org-modern) ;; Voce usou configuracoes dele no config.el

;; --- DEV & TOOLS ---
(package! treesit-auto)
(package! harpoon)

(package! grease
  :recipe (:local-repo "lisp/grease"))
;; :recipe (:host github :repo "mwac-dev/grease.el"  :files ("*.el")))

;; (package! gcmh)  ; Ja incluido no Doom por padrao
(package! kdl-mode)
(package! consult-lsp)

;; --- NEOVIM PARITY PACKAGES ---
;; NOTA: Estes pacotes trabalham em conjunto com o modulo :emacs dired ja habilitado em init.el
;; - dirvish: Substitui/extend o dired tradicional com interface Oil.nvim-like
;; - dired-subtree: Funciona junto com dired para expandir/colapsar diretorios
(package! dirvish)
(package! dired-subtree)

;; Incremental rename & editing
(package! iedit)

;; Git gutter/diff highlighting
(package! diff-hl)

;; QoL improvements
(package! evil-escape)
(package! pulsar)
(package! consult-dir)

;; NOTAS SOBRE REMOCOES:
;; - vertico, orderless, consult, embark, marginalia: Removidos pois o modulo :completion vertico ja instala.
;; - corfu, corfu-terminal: Removidos pois o modulo :completion corfu ja instala.
;; - js2-mode: Removido pois o modulo :lang javascript ja traz suporte adequado (e treesitter e o futuro).
;; - org-bullets: Obsoleto, o Doom usa org-superstar nativamente.
