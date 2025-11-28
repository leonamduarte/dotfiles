
;;; bindings.el --- Leader key e keybindings globais estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo implementa um sistema de leader key altamente inspirado no Doom Emacs:
;; - Usa SPC como líder (em Evil)
;; - Prefixos bem definidos: f, b, p, g, l, w, o, s, h, q, x
;; - Safe-wrappers para evitar erros quando comandos não estão disponíveis
;; - Suporte total a sub-prefixos (ex.: SPC o i a)
;;
;;; Code:

(require 'cl-lib)

;; ----------------------------------------------------------------------------
;; Leader Key Setup
;; ----------------------------------------------------------------------------

(defvar leo/leader-key "SPC"
  "Tecla líder no Evil.")

(defvar leo/leader-map (make-sparse-keymap)
  "Mapa principal utilizado pelo leader key.")

;; Bloqueia SPC globalmente (estilo Doom)
(global-set-key (kbd "SPC") nil)

;; Conecta SPC ao leader somente quando Evil estiver carregado
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd leo/leader-key) leo/leader-map)
  (define-key evil-visual-state-map (kbd leo/leader-key) leo/leader-map)
  (define-key evil-motion-state-map (kbd leo/leader-key) leo/leader-map))

(defun leo/leader (key func-or-map)
  "Define KEY no mapa líder chamando FUNC-OR-MAP."
  (define-key leo/leader-map (kbd key) func-or-map))

;; Safe wrapper para comandos que talvez não existam
(defun leo/leader-make-cmd (sym)
  "Cria (ou retorna) um comando interativo que chama SYM, sem depender de closure."
  (let* ((name (intern (format "leo/leader-cmd-%s" (symbol-name sym)))))
    (unless (fboundp name)
      (defalias name
        `(lambda ()
           (interactive)
           (if (fboundp ',sym)
               (call-interactively ',sym)
             (user-error "Comando não disponível: %s" ',sym)))
        (format "Wrapper to call %s if available." sym)))
    name))

;; ----------------------------------------------------------------------------
;; Prefixes
;; ----------------------------------------------------------------------------

(define-prefix-command 'leo/leader-file-map)     (leo/leader "f" leo/leader-file-map)
(define-prefix-command 'leo/leader-buffer-map)   (leo/leader "b" leo/leader-buffer-map)
(define-prefix-command 'leo/leader-project-map)  (leo/leader "p" leo/leader-project-map)
(define-prefix-command 'leo/leader-git-map)      (leo/leader "g" leo/leader-git-map)
(define-prefix-command 'leo/leader-lsp-map)      (leo/leader "l" leo/leader-lsp-map)
(define-prefix-command 'leo/leader-window-map)   (leo/leader "w" leo/leader-window-map)
(define-prefix-command 'leo/leader-org-map)      (leo/leader "o" leo/leader-org-map)
(define-prefix-command 'leo/leader-search-map)   (leo/leader "s" leo/leader-search-map)
(define-prefix-command 'leo/leader-help-map)     (leo/leader "h" leo/leader-help-map)
(define-prefix-command 'leo/leader-misc-map)     (leo/leader "x" leo/leader-misc-map)
(define-prefix-command 'leo/leader-quit-map)     (leo/leader "q" leo/leader-quit-map)

;; Subprefix para Org-roam
(define-prefix-command 'leo/leader-org-roam-map)
(define-key leo/leader-org-map (kbd "r") leo/leader-org-roam-map)

;; Prefixo de insert no Org (para SPC o i a)
(define-prefix-command 'leo/leader-org-insert-map)
(define-key leo/leader-org-map (kbd "i") leo/leader-org-insert-map)

;; ----------------------------------------------------------------------------
;; Files (SPC f)
;; ----------------------------------------------------------------------------

(define-key leo/leader-file-map (kbd "f") #'find-file)
(define-key leo/leader-file-map (kbd "r") (leo/leader-make-cmd 'consult-recent-file))
(define-key leo/leader-file-map (kbd "s") #'save-buffer)
(define-key leo/leader-file-map (kbd "d") #'dired)

(define-key leo/leader-file-map (kbd "p")
  (lambda ()
    (interactive)
    (let ((default-directory user-emacs-directory))
      (call-interactively #'find-file))))

(define-key leo/leader-file-map (kbd "e")
  (lambda () (interactive)
    (find-file (expand-file-name "init.el" user-emacs-directory))))

(leo/leader "." #'find-file)

;; ----------------------------------------------------------------------------
;; Buffers (SPC b)
;; ----------------------------------------------------------------------------

(define-key leo/leader-buffer-map (kbd "b") (leo/leader-make-cmd 'consult-buffer))
(define-key leo/leader-buffer-map (kbd "k") #'kill-current-buffer)
(define-key leo/leader-buffer-map (kbd "n") #'next-buffer)
(define-key leo/leader-buffer-map (kbd "p") #'previous-buffer)
(define-key leo/leader-buffer-map (kbd "s") #'save-buffer)

;; ----------------------------------------------------------------------------
;; Projects (SPC p)
;; ----------------------------------------------------------------------------

(define-key leo/leader-project-map (kbd "p") (leo/leader-make-cmd 'project-switch-project))
(define-key leo/leader-project-map (kbd "f") (leo/leader-make-cmd 'project-find-file))
(define-key leo/leader-project-map (kbd "s") (leo/leader-make-cmd 'consult-ripgrep))
(define-key leo/leader-project-map (kbd "e")
  (lambda ()
    (interactive)
    (if (fboundp 'project-eshell)
        (project-eshell)
      (user-error "project-eshell não disponível"))))
(define-key leo/leader-project-map (kbd "c")
  (lambda () (interactive) (compile "make")))

;; ----------------------------------------------------------------------------
;; Git (SPC g)
;; ----------------------------------------------------------------------------

;; Wrappers seguros
(define-key leo/leader-git-map (kbd "g") (leo/leader-make-cmd 'magit-status))
(define-key leo/leader-git-map (kbd "b") (leo/leader-make-cmd 'magit-blame))
(define-key leo/leader-git-map (kbd "d") (leo/leader-make-cmd 'magit-diff))
(define-key leo/leader-git-map (kbd "l") (leo/leader-make-cmd 'magit-log-all))

;; Substituições pós-load (estilo Doom)
(with-eval-after-load 'magit
  (define-key leo/leader-git-map (kbd "g") #'magit-status)
  (define-key leo/leader-git-map (kbd "b") #'magit-blame)
  (define-key leo/leader-git-map (kbd "d") #'magit-diff)
  (define-key leo/leader-git-map (kbd "l") #'magit-log-all))

;; ----------------------------------------------------------------------------
;; LSP / Eglot (SPC l)
;; ----------------------------------------------------------------------------

(define-key leo/leader-lsp-map (kbd "r") (leo/leader-make-cmd 'eglot-rename))
(define-key leo/leader-lsp-map (kbd "a") (leo/leader-make-cmd 'eglot-code-actions))
(define-key leo/leader-lsp-map (kbd "f") (leo/leader-make-cmd 'eglot-format))
(define-key leo/leader-lsp-map (kbd "d") (leo/leader-make-cmd 'eldoc-doc-buffer))
(define-key leo/leader-lsp-map (kbd "e") (leo/leader-make-cmd 'flymake-show-project-diagnostics))

;; ----------------------------------------------------------------------------
;; Windows (SPC w)
;; ----------------------------------------------------------------------------

(define-key leo/leader-window-map (kbd "v") #'split-window-right)
(define-key leo/leader-window-map (kbd "s") #'split-window-below)
(define-key leo/leader-window-map (kbd "d") #'delete-window)
(define-key leo/leader-window-map (kbd "o") #'delete-other-windows)

(define-key leo/leader-window-map (kbd "h") #'windmove-left)
(define-key leo/leader-window-map (kbd "j") #'windmove-down)
(define-key leo/leader-window-map (kbd "k") #'windmove-up)
(define-key leo/leader-window-map (kbd "l") #'windmove-right)

;; ----------------------------------------------------------------------------
;; Search (SPC s)
;; ----------------------------------------------------------------------------

(define-key leo/leader-search-map (kbd "d") (leo/leader-make-cmd 'consult-ripgrep))
(define-key leo/leader-search-map (kbd "p") (leo/leader-make-cmd 'consult-ripgrep))
(define-key leo/leader-search-map (kbd "b") (leo/leader-make-cmd 'consult-line))
(define-key leo/leader-search-map (kbd "g") (leo/leader-make-cmd 'consult-grep))

;; ----------------------------------------------------------------------------
;; Org (SPC o)
;; ----------------------------------------------------------------------------

(define-key leo/leader-org-map (kbd "a") (leo/leader-make-cmd 'org-agenda))
(define-key leo/leader-org-map (kbd "c") (leo/leader-make-cmd 'org-capture))
(define-key leo/leader-org-map (kbd "j") (leo/leader-make-cmd 'leo/org-journal-today))

(define-key leo/leader-org-map (kbd "B") (leo/leader-make-cmd 'org-babel-tangle))

;; Subprefix insert (SPC o i …)
(define-key leo/leader-org-insert-map (kbd "a")
  (leo/leader-make-cmd 'leo/org-insert-auto-tangle))

;; Org-roam
(define-key leo/leader-org-roam-map (kbd "f") (leo/leader-make-cmd 'org-roam-node-find))
(define-key leo/leader-org-roam-map (kbd "i") (leo/leader-make-cmd 'org-roam-node-insert))
(define-key leo/leader-org-roam-map (kbd "r") (leo/leader-make-cmd 'org-roam-buffer-toggle))

;; ----------------------------------------------------------------------------
;; Help (SPC h)
;; ----------------------------------------------------------------------------

(define-key leo/leader-help-map (kbd "n") (leo/leader-make-cmd 'view-emacs-news))
(define-key leo/leader-help-map (kbd "m") (leo/leader-make-cmd 'info-emacs-manual))

;; ----------------------------------------------------------------------------
;; Misc (SPC x)
;; ----------------------------------------------------------------------------

(define-key leo/leader-misc-map (kbd "s")
  (lambda () (interactive) (switch-to-buffer "*scratch*")))

;; ----------------------------------------------------------------------------
;; Quit / Session (SPC q)
;; ----------------------------------------------------------------------------

(define-key leo/leader-quit-map (kbd "q")
  (lambda () (interactive) (save-buffers-kill-terminal)))

(define-key leo/leader-quit-map (kbd "r")
  (leo/leader-make-cmd 'restart-emacs))

(defun leo/reload-config ()
  "Recarrega init.el do user-emacs-directory."
  (interactive)
  (let ((path (expand-file-name "init.el" user-emacs-directory)))
    (if (file-exists-p path)
        (progn
          (load-file path)
          (message "✔ Configuração recarregada!"))
      (user-error "init.el não encontrado em %s" user-emacs-directory))))

(define-key leo/leader-quit-map (kbd "R") #'leo/reload-config)

;; ----------------------------------------------------------------------------
;; Atalho global opcional
;; ----------------------------------------------------------------------------

(when (fboundp 'leo/org-journal-today)
  (global-set-key (kbd "C-c o j") #'leo/org-journal-today))

(provide 'bindings)
;;; bindings.el ends here

