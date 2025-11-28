
;;; bindings.el --- Leader key e keybindings globais estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Sistema completo de leader key inspirado no Doom Emacs:
;; - SPC como líder
;; - Prefixos organizados: f, b, p, g, l, w, o, s, q, h, x
;; - Atalhos de arquivos, buffers, janelas, git, LSP, org, projetos e utilidades

;;; Code:

;; -----------------------------------------------------------------------------
;;  Leader Key System
;; -----------------------------------------------------------------------------

(defvar leo/leader-key "SPC"
  "Tecla líder no Evil.")

(defvar leo/leader-map (make-sparse-keymap)
  "Mapa principal do leader.")

(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd leo/leader-key) leo/leader-map)
  (define-key evil-visual-state-map (kbd leo/leader-key) leo/leader-map)
  (define-key evil-motion-state-map (kbd leo/leader-key) leo/leader-map))

(defun leo/leader (key func)
  (define-key leo/leader-map (kbd key) func))

;; -----------------------------------------------------------------------------
;; Prefixes Doom-like
;; -----------------------------------------------------------------------------

(define-prefix-command 'leo/leader-file-map)     (leo/leader "f" leo/leader-file-map)
(define-prefix-command 'leo/leader-buffer-map)   (leo/leader "b" leo/leader-buffer-map)
(define-prefix-command 'leo/leader-project-map)  (leo/leader "p" leo/leader-project-map)
(define-prefix-command 'leo/leader-git-map)      (leo/leader "g" leo/leader-git-map)
(define-prefix-command 'leo/leader-lsp-map)      (leo/leader "l" leo/leader-lsp-map)
(define-prefix-command 'leo/leader-window-map)   (leo/leader "w" leo/leader-window-map)
(define-prefix-command 'leo/leader-org-map)      (leo/leader "o" leo/leader-org-map)
(define-prefix-command 'leo/leader-search-map)   (leo/leader "s" leo/leader-search-map)
(define-prefix-command 'leo/leader-help-map)     (leo/leader "h" leo/leader-help-map)

;; -----------------------------------------------------------------------------
;;  Files (SPC f)
;; -----------------------------------------------------------------------------

(define-key leo/leader-file-map (kbd "f") #'find-file)
(define-key leo/leader-file-map (kbd "r") #'consult-recent-file)
(define-key leo/leader-file-map (kbd "s") #'save-buffer)
(define-key leo/leader-file-map (kbd "d") #'dired)

;; Open Emacs config directory
;; (define-key leo/leader-file-map (kbd "p")
;;   (lambda () (interactive) (find-file user-emacs-directory)))
(define-key leo/leader-file-map (kbd "p")
  (lambda ()
    (interactive)
    (let ((default-directory user-emacs-directory))
      (call-interactively #'find-file))))


;; Open init.el
(define-key leo/leader-file-map (kbd "e")
  (lambda () (interactive)
    (find-file (expand-file-name "init.el" user-emacs-directory))))

;; Doom-like SP/. → find-file
(leo/leader "." #'find-file)

;; -----------------------------------------------------------------------------
;; Buffers (SPC b)
;; -----------------------------------------------------------------------------

(define-key leo/leader-buffer-map (kbd "b") #'consult-buffer)
(define-key leo/leader-buffer-map (kbd "k") #'kill-current-buffer)
(define-key leo/leader-buffer-map (kbd "n") #'next-buffer)
(define-key leo/leader-buffer-map (kbd "p") #'previous-buffer)
(define-key leo/leader-buffer-map (kbd "s") #'save-buffer)

;; -----------------------------------------------------------------------------
;; Projects (SPC p)
;; -----------------------------------------------------------------------------

(define-key leo/leader-project-map (kbd "p") #'project-switch-project)
(define-key leo/leader-project-map (kbd "f") #'project-find-file)
(define-key leo/leader-project-map (kbd "s") #'consult-ripgrep)
(define-key leo/leader-project-map (kbd "e")
  (lambda () (interactive) (project-eshell)))
(define-key leo/leader-project-map (kbd "c")
  (lambda () (interactive) (compile "make")))

;; -----------------------------------------------------------------------------
;; Git (SPC g)
;; -----------------------------------------------------------------------------

(define-key leo/leader-git-map (kbd "g") #'magit-status)
(define-key leo/leader-git-map (kbd "b") #'magit-blame)
(define-key leo/leader-git-map (kbd "d") #'magit-diff)
(define-key leo/leader-git-map (kbd "l") #'magit-log-all)

;; -----------------------------------------------------------------------------
;; LSP / Eglot (SPC l)
;; -----------------------------------------------------------------------------

(define-key leo/leader-lsp-map (kbd "r") #'eglot-rename)
(define-key leo/leader-lsp-map (kbd "a") #'eglot-code-actions)
(define-key leo/leader-lsp-map (kbd "f") #'eglot-format)
(define-key leo/leader-lsp-map (kbd "d") #'eldoc-doc-buffer)
(define-key leo/leader-lsp-map (kbd "e") #'flymake-show-project-diagnostics)

;; -----------------------------------------------------------------------------
;; Windows (SPC w)
;; -----------------------------------------------------------------------------

(define-key leo/leader-window-map (kbd "v") #'split-window-right)
(define-key leo/leader-window-map (kbd "s") #'split-window-below)
(define-key leo/leader-window-map (kbd "d") #'delete-window)
(define-key leo/leader-window-map (kbd "o") #'delete-other-windows)

;; Doom window movement
(define-key leo/leader-window-map (kbd "h") #'windmove-left)
(define-key leo/leader-window-map (kbd "j") #'windmove-down)
(define-key leo/leader-window-map (kbd "k") #'windmove-up)
(define-key leo/leader-window-map (kbd "l") #'windmove-right)

;; -----------------------------------------------------------------------------
;; Search (SPC s)
;; -----------------------------------------------------------------------------

;; Doom-like search directory
(define-key leo/leader-search-map (kbd "d") #'consult-ripgrep)

;; Doom search project
(define-key leo/leader-search-map (kbd "p") #'consult-ripgrep)

;; Search in current buffer
(define-key leo/leader-search-map (kbd "b") #'consult-line)

;; Fallback grep
(define-key leo/leader-search-map (kbd "g") #'consult-grep)

;; -----------------------------------------------------------------------------
;; Org (SPC o)
;; -----------------------------------------------------------------------------

(define-key leo/leader-org-map (kbd "a") #'org-agenda)
(define-key leo/leader-org-map (kbd "c") #'org-capture)
(define-key leo/leader-org-map (kbd "j") #'leo/org-journal-today)
(define-key leo/leader-org-map (kbd "r") #'org-roam-node-find)

;; -----------------------------------------------------------------------------
;; Help (SPC h)
;; -----------------------------------------------------------------------------

(define-key leo/leader-help-map (kbd "n") #'view-emacs-news)
(define-key leo/leader-help-map (kbd "m") #'info-emacs-manual)

;; -----------------------------------------------------------------------------
;; Misc (SPC x, SPC q)
;; -----------------------------------------------------------------------------

;; Scratch buffer
(leo/leader "x"
            (lambda () (interactive) (switch-to-buffer "*scratch*")))

;; Quit / restart / reload config
(leo/leader "q q" #'save-buffers-kill-terminal)
(leo/leader "q r" #'restart-emacs)

(defun leo/reload-config ()
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (message "✔ Configuração recarregada!"))

(leo/leader "q R" #'leo/reload-config)

(provide 'bindings)

;;; bindings.el ends here

