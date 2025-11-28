;;; bindings.el --- Leader key e keybindings globais estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Sistema de leader key inspirado no Doom Emacs, com ligações defensivas para
;; evitar erros quando pacotes ainda não foram carregados/instalados.
;;
;; - SPC como líder
;; - Prefixos organizados: f, b, p, g, l, w, o, s, q, h, x
;; - As ligações verificam se o comando existe antes de chamar
;;
;;; Code:

(require 'cl-lib)

;; ---------------------------------------------------------------------------
;;  Leader Key System
;; ---------------------------------------------------------------------------

(defvar leo/leader-key "SPC"
  "Tecla líder no Evil.")

(defvar leo/leader-map (make-sparse-keymap)
  "Mapa principal do leader.")

;; Só define a ligação do leader quando o Evil estiver carregado.
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd leo/leader-key) leo/leader-map)
  (define-key evil-visual-state-map (kbd leo/leader-key) leo/leader-map)
  (define-key evil-motion-state-map (kbd leo/leader-key) leo/leader-map))

(defun leo/leader (key func-or-map)
  "Bind KEY in `leo/leader-map' to FUNC-OR-MAP.
FUNC-OR-MAP can be a command symbol, a keymap or a lambda."
  (define-key leo/leader-map (kbd key) func-or-map))

;; Helper: cria um wrapper interativo que chama SYM se estiver definido,
;; senão mostra uma mensagem de erro amigável.
(defun leo/leader-make-cmd (sym)
  "Return an interactive lambda that calls SYM if available, else errors."
  (let ((s sym))
    (lambda ()
      (interactive)
      (if (fboundp s)
          (call-interactively s)
        (user-error "Comando não disponível: %s" s)))))

;; ---------------------------------------------------------------------------
;; Prefixes Doom-like
;; ---------------------------------------------------------------------------

(define-prefix-command 'leo/leader-file-map)     (leo/leader "f" leo/leader-file-map)
(define-prefix-command 'leo/leader-buffer-map)   (leo/leader "b" leo/leader-buffer-map)
(define-prefix-command 'leo/leader-project-map)  (leo/leader "p" leo/leader-project-map)
(define-prefix-command 'leo/leader-git-map)      (leo/leader "g" leo/leader-git-map)
(define-prefix-command 'leo/leader-lsp-map)      (leo/leader "l" leo/leader-lsp-map)
(define-prefix-command 'leo/leader-window-map)   (leo/leader "w" leo/leader-window-map)
(define-prefix-command 'leo/leader-org-map)      (leo/leader "o" leo/leader-org-map)
(define-prefix-command 'leo/leader-search-map)   (leo/leader "s" leo/leader-search-map)
(define-prefix-command 'leo/leader-help-map)     (leo/leader "h" leo/leader-help-map)

;; Subprefix para Org-roam
(define-prefix-command 'leo/leader-org-roam-map)
(define-key leo/leader-org-map (kbd "r") leo/leader-org-roam-map)

;; ---------------------------------------------------------------------------
;;  Files (SPC f)
;; ---------------------------------------------------------------------------

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

;; ---------------------------------------------------------------------------
;; Buffers (SPC b)
;; ---------------------------------------------------------------------------

(define-key leo/leader-buffer-map (kbd "b") (leo/leader-make-cmd 'consult-buffer))
(define-key leo/leader-buffer-map (kbd "k") #'kill-current-buffer)
(define-key leo/leader-buffer-map (kbd "n") #'next-buffer)
(define-key leo/leader-buffer-map (kbd "p") #'previous-buffer)
(define-key leo/leader-buffer-map (kbd "s") #'save-buffer)

;; ---------------------------------------------------------------------------
;; Projects (SPC p)
;; ---------------------------------------------------------------------------

(define-key leo/leader-project-map (kbd "p") (leo/leader-make-cmd 'project-switch-project))
(define-key leo/leader-project-map (kbd "f") (leo/leader-make-cmd 'project-find-file))
(define-key leo/leader-project-map (kbd "s") (leo/leader-make-cmd 'consult-ripgrep))
(define-key leo/leader-project-map (kbd "e")
  (lambda () (interactive)
    (if (fboundp 'project-eshell)
        (project-eshell)
      (user-error "project-eshell não disponível"))))
(define-key leo/leader-project-map (kbd "c")
  (lambda () (interactive) (compile "make")))

;; ---------------------------------------------------------------------------
;; Git (SPC g)
;; ---------------------------------------------------------------------------
;; Bindings defensivas: se Magit existir, ligamos diretamente; se não, mantemos
;; um wrapper que informa que o comando não está disponível.

;; Wrappers iniciais seguros:
(define-key leo/leader-git-map (kbd "g") (leo/leader-make-cmd 'magit-status))
(define-key leo/leader-git-map (kbd "b") (leo/leader-make-cmd 'magit-blame))
(define-key leo/leader-git-map (kbd "d") (leo/leader-make-cmd 'magit-diff))
(define-key leo/leader-git-map (kbd "l") (leo/leader-make-cmd 'magit-log-all))

;; Depois que magit for carregado, substituímos por ligações diretas (mais limpas).
(with-eval-after-load 'magit
  (define-key leo/leader-git-map (kbd "g") #'magit-status)
  (define-key leo/leader-git-map (kbd "b") #'magit-blame)
  (define-key leo/leader-git-map (kbd "d") #'magit-diff)
  (define-key leo/leader-git-map (kbd "l") #'magit-log-all))

;; ---------------------------------------------------------------------------
;; LSP / Eglot (SPC l)
;; ---------------------------------------------------------------------------

(define-key leo/leader-lsp-map (kbd "r") (leo/leader-make-cmd 'eglot-rename))
(define-key leo/leader-lsp-map (kbd "a") (leo/leader-make-cmd 'eglot-code-actions))
(define-key leo/leader-lsp-map (kbd "f") (leo/leader-make-cmd 'eglot-format))
(define-key leo/leader-lsp-map (kbd "d") (leo/leader-make-cmd 'eldoc-doc-buffer))
(define-key leo/leader-lsp-map (kbd "e") (leo/leader-make-cmd 'flymake-show-project-diagnostics))

;; ---------------------------------------------------------------------------
;; Windows (SPC w)
;; ---------------------------------------------------------------------------

(define-key leo/leader-window-map (kbd "v") #'split-window-right)
(define-key leo/leader-window-map (kbd "s") #'split-window-below)
(define-key leo/leader-window-map (kbd "d") #'delete-window)
(define-key leo/leader-window-map (kbd "o") #'delete-other-windows)

(define-key leo/leader-window-map (kbd "h") #'windmove-left)
(define-key leo/leader-window-map (kbd "j") #'windmove-down)
(define-key leo/leader-window-map (kbd "k") #'windmove-up)
(define-key leo/leader-window-map (kbd "l") #'windmove-right)

;; ---------------------------------------------------------------------------
;; Search (SPC s)
;; ---------------------------------------------------------------------------

(define-key leo/leader-search-map (kbd "d") (leo/leader-make-cmd 'consult-ripgrep))
(define-key leo/leader-search-map (kbd "p") (leo/leader-make-cmd 'consult-ripgrep))
(define-key leo/leader-search-map (kbd "b") (leo/leader-make-cmd 'consult-line))
(define-key leo/leader-search-map (kbd "g") (leo/leader-make-cmd 'consult-grep))

;; ---------------------------------------------------------------------------
;; Org (SPC o)
;; ---------------------------------------------------------------------------

(define-key leo/leader-org-map (kbd "a") (leo/leader-make-cmd 'org-agenda))
(define-key leo/leader-org-map (kbd "c") (leo/leader-make-cmd 'org-capture))
(define-key leo/leader-org-map (kbd "j") (leo/leader-make-cmd 'leo/org-journal-today))

(define-key leo/leader-org-map (kbd "B") (leo/leader-make-cmd 'org-babel-tangle))
(define-key leo/leader-org-map (kbd "i a") (leo/leader-make-cmd 'leo/org-insert-auto-tangle))

;; ---- Org-roam (SPC o r …) ----
(define-key leo/leader-org-roam-map (kbd "f") (leo/leader-make-cmd 'org-roam-node-find))
(define-key leo/leader-org-roam-map (kbd "i") (leo/leader-make-cmd 'org-roam-node-insert))
(define-key leo/leader-org-roam-map (kbd "r") (leo/leader-make-cmd 'org-roam-buffer-toggle))

;; ---------------------------------------------------------------------------
;; Help (SPC h)
;; ---------------------------------------------------------------------------

(define-key leo/leader-help-map (kbd "n") (leo/leader-make-cmd 'view-emacs-news))
(define-key leo/leader-help-map (kbd "m") (leo/leader-make-cmd 'info-emacs-manual))

;; ---------------------------------------------------------------------------
;; Misc (SPC x, SPC q)
;; ---------------------------------------------------------------------------

(leo/leader "x"
            (lambda () (interactive) (switch-to-buffer "*scratch*")))

(leo/leader "q q" (lambda () (interactive) (save-buffers-kill-terminal)))
(leo/leader "q r" (leo/leader-make-cmd 'restart-emacs))

(defun leo/reload-config ()
  "Recarrega init.el do `user-emacs-directory'."
  (interactive)
  (let ((path (expand-file-name "init.el" user-emacs-directory)))
    (if (file-exists-p path)
        (progn
          (load-file path)
          (message "✔ Configuração recarregada!"))
      (user-error "init.el não encontrado em %s" user-emacs-directory))))

(leo/leader "q R" #'leo/reload-config)

;; Atalho global preservado do módulo Org (somente se disponível)
(when (fboundp 'leo/org-journal-today)
  (global-set-key (kbd "C-c o j") #'leo/org-journal-today))

(provide 'bindings)
;;; bindings.el ends here
