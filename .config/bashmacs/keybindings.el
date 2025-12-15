;;; keybindings.el --- Doom-like keybindings -*- lexical-binding: t -*-

;; Este arquivo ASSUME que:
;; - general já foi carregado
;; - evil já está ativo
;; Ele NÃO instala pacotes

;; ---------------------------------------------------------
;; MAPA GERAL (DOOM STYLE)
;; ---------------------------------------------------------

;; ---------------------------------------------------------
;; Funções utilitárias
;; ---------------------------------------------------------

(defun leonam/reload-config ()
  "Reload the entire Emacs configuration."
  (interactive)
  (load-file user-init-file)
  (message "Config reloaded successfully."))

(defun leonam/consult-ripgrep-smart ()
  (interactive)
  (if (project-current)
      (consult-ripgrep (project-root (project-current)))
    (consult-ripgrep)))

;; ---------------------------------------------------------
;; Leader keybindings (Doom-like)
;; ---------------------------------------------------------

(leonam/leader-keys

 ;; --- SPC SPC ---
 "SPC" '(execute-extended-command :which-key "M-x")

 ;; --- Files ---
 "."  '(find-file :which-key "Find file")
 "f"   '(:ignore t :which-key "files")
 "f f"  '(find-file :which-key "Find file")
 "f s"  '(save-buffer :which-key "Save file")
 "f r"  '(consult-recent-file :which-key "Recent files")
 "f p"  '((lambda ()
           (interactive)
           (find-file (expand-file-name "config.el" user-emacs-directory)))
         :which-key "Open config.el")
 "f i"  '((lambda ()
           (interactive)
           (find-file user-init-file))
         :which-key "Open init.el")

 ;; --- Buffers ---
 "b"   '(:ignore t :which-key "buffers")
 "b b"  '(switch-to-buffer :which-key "Switch buffer")
 "b k"  '(kill-current-buffer :which-key "Kill buffer")
 "b d"  '(kill-buffer :which-key "Kill buffer (choose)")
  "b n" '(next-buffer :which-key "next buffer")
    "b p" '(previous-buffer :which-key "prev buffer")

 ;; --- Projects ---
 "p"  '(:ignore t :which-key "project")

 ;; Projeto
 "p p" '(consult-projectile-switch-project :which-key "switch project")
 "p f" '(consult-projectile-find-file :which-key "find file in project")
 "p s" '(consult-projectile-ripgrep :which-key "search in project")

 ;; Buffers do projeto
 "p b" '(consult-projectile-switch-to-buffer :which-key "project buffers")

 ;; --- Git / Magit ---
 "g"   '(:ignore t :which-key "git")
 "g g"  '(magit-status :which-key "Magit status")
 "g c"  '(magit-commit-create :which-key "Commit")
 "g p"  '(magit-push-current-to-pushremote :which-key "Push")
 "g l"  '(magit-log-current :which-key "Log")
 "g b"  '(magit-branch :which-key "Branch")

 ;; --- Code / LSP ---
 "c"   '(:ignore t :which-key "code")
 "c a"  '(lsp-execute-code-action :which-key "Code action")
 "c r"  '(lsp-rename :which-key "Rename symbol")
 "c d"  '(lsp-find-definition :which-key "Go to definition")
 "c D"  '(lsp-find-references :which-key "Find references")
 "c f"  '(apheleia-format-buffer :which-key "Format buffer")

 ;; --- Help ---
 "h"   '(:ignore t :which-key "help")
 "h f"  '(describe-function :which-key "Describe function")
 "h v"  '(describe-variable :which-key "Describe variable")
 "h k"  '(describe-key :which-key "Describe key")

 ;; --- Reload ---
 "h r"  '(:ignore t :which-key "reload")
 "h r r" '(leonam/reload-config :which-key "Reload config")
 "h r i" '((lambda () (interactive) (load-file user-init-file))
         :which-key "Reload init.el")

 ;; --- Quit / Session ---
 "q"   '(:ignore t :which-key "quit")
 "q q"  '(save-buffers-kill-terminal :which-key "Quit Emacs")
 "q R"  '(restart-emacs :which-key "Restart Emacs")

 ;; --- Search ---
 "s"   '(:ignore t :which-key "search")
 "s r"  '(consult-ripgrep :which-key "Ripgrep")
 "s b"  '(consult-line :which-key "Search buffer")

  "r"  '(:ignore t :which-key "org")
  "r a" '(org-agenda :which-key "agenda")
  "r c" '(org-capture :which-key "capture")

  "o"  '(:ignore t :which-key "open")
  "o t" '(treemacs :which-key "treemacs")
  "o d" '(dashboard-open :which-key "dashboard")

  "m"  '(:ignore t :which-key "org-mode")
  "m t" '(org-todo :which-key "todo")
  "m B" '(org-babel-tangle :which-key "tangle")
  "m i" '(leonam/org-insert-auto-tangle-tag :which-key "insert auto_tangle")
 
 ;; Doom-style global search
    "/" '(leonam/consult-ripgrep-smart :which-key "search")
 
 ;; --- Windows ---
 "w"   '(:ignore t :which-key "windows")
 "w s"  '(evil-window-split :which-key "Split horizontal")
 "w v"  '(evil-window-vsplit :which-key "Split vertical")
 "w d"  '(delete-window :which-key "Delete window")
 "w o"  '(delete-other-windows :which-key "Delete others")

 ;; --- Toggles ---
 "t"   '(:ignore t :which-key "toggle")
 "t n"  '(display-line-numbers-mode :which-key "Line numbers")
 "t w"  '(visual-line-mode :which-key "Visual line")
 )


(provide 'keybindings)
