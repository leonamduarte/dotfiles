;;; config.el --- Doom -> LazyVim parity -*- lexical-binding: t; -*-
;;; Commentary:
;; Este arquivo contém minhas configurações pessoais do Doom Emacs,
;; focadas em replicar a experiência do LazyVim para desenvolvimento fullstack.
;;
;;; Code:

;; Tema & fonte
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16))
;; UI
(setq display-line-numbers-type 'relative
      doom-modeline-icon t
      doom-modeline-major-mode-icon t)

;; Projetos
(setq projectile-project-search-path '("~/code" "~/projetos" "/run/media/lm/dev")
      projectile-indexing-method 'alien
      projectile-auto-discover t)

;; Leader (Space já é leader no Doom)
(map! :leader
      :desc "VTerm toggle"        "t t" #'+vterm/toggle
      :desc "Dirvish (oil-like)"  "e"   #'dirvish
      :desc "Find file"           "f f" #'find-file
      :desc "Search project"      "s p" #'consult-ripgrep
      :desc "Buffers"             "b b" #'ibuffer
      :desc "Code actions"        "c a" #'lsp-execute-code-action
      :desc "Format buffer"       "c f" #'apheleia-format-buffer
      :desc "Rename symbol"       "c r" #'lsp-rename
      :desc "Treemacs"            "o t" #'treemacs)

;; Dirvish (Dired turbinado)
(use-package! dirvish
  :init (dirvish-override-dired-mode)
  :config
  (setq dirvish-attributes '(all-the-icons file-time file-size git-msg)
        dirvish-mode-line-format '(:left (sort file-time) :right (omit yank index))
        dirvish-subtree-always-show-state t)
  (map! :leader :desc "Dirvish here" "e" #'dirvish
        :desc "Dirvish side" "E" #'dirvish-side)
  (map! :map dirvish-mode-map
        :n "RET" #'dired-find-file
        :n "q"   #'dirvish-quit))

;; LSP geral (lsp-mode). Para Eglot, veja nota mais abaixo.
(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable t
        lsp-semantic-tokens-enable t
        lsp-enable-file-watchers t
        lsp-idle-delay 0.2
        lsp-log-io nil)
  (add-hook 'typescript-ts-mode-hook #'lsp!)
  (add-hook 'tsx-ts-mode-hook         #'lsp!)
  (add-hook 'js-ts-mode-hook          #'lsp!)
  (add-hook 'json-ts-mode-hook        #'lsp!))

;; Tree-sitter (Emacs 29+)
(add-hook 'typescript-ts-mode-hook #'tree-sitter-hl-mode)
(add-hook 'tsx-ts-mode-hook         #'tree-sitter-hl-mode)
(add-hook 'js-ts-mode-hook          #'tree-sitter-hl-mode)

;; node_modules/.bin no PATH do buffer
(use-package! add-node-modules-path
  :hook ((js-ts-mode tsx-ts-mode typescript-ts-mode web-mode) . add-node-modules-path))

;; Apheleia: formatação on save
(use-package! apheleia
  :config
  ;; Preferir prettier local do projeto
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))
  (dolist (hook '(js-ts-mode-hook tsx-ts-mode-hook typescript-ts-mode-hook
                                  json-ts-mode-hook css-mode-hook scss-mode-hook
                                  web-mode-hook python-mode-hook go-mode-hook))
    (add-hook hook #'apheleia-mode))
  ;; Evitar conflitos com :editor (format +onsave)
  (setq +format-on-save-enabled-modes '(not emacs-lisp-mode sql-mode tex-mode)))

;; Web-mode/HTML/CSS
(after! web-mode
  (setq web-mode-enable-auto-quoting nil
        web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2))

;; Tailwind (opcional)
(use-package! lsp-tailwindcss
  :after lsp-mode
  :init (add-hook 'web-mode-hook #'lsp)
  :config (setq lsp-tailwindcss-add-on-mode t))

;; Snippets
(after! yasnippet
  (yas-global-mode 1))

;; Git
(after! magit
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))
(after! vc-gutter
  (setq diff-hl-draw-borders nil))

;; Testes (Jest)
(use-package! jest-test-mode
  :hook ((js-ts-mode tsx-ts-mode typescript-ts-mode) . jest-test-mode)
  :config
  (map! :leader
        :desc "Jest file"      "t f" #'jest-test-run
        :desc "Jest at point"  "t t" #'jest-test-run-at-point
        :desc "Jest watch"     "t w" #'jest-test-run-watch))

;; Qualidade de vida
(setq confirm-kill-emacs nil) ; sair sem confirmar
(setq-default tab-width 2 indent-tabs-mode nil)

;; --- Se optar por Eglot no lugar de lsp-mode ---
;; (add-hook 'typescript-ts-mode-hook #'eglot-ensure)
;; (add-hook 'tsx-ts-mode-hook         #'eglot-ensure)
;; (add-hook 'js-ts-mode-hook          #'eglot-ensure)
;; (add-hook 'json-ts-mode-hook        #'eglot-ensure)

