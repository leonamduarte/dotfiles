;;; keybindings.el --- Seus Atalhos estilo Doom Emacs -*- lexical-binding: t -*-

;; Autor: bashln
;; Descri√ß√£o: Configura√ß√£o de atalhos personalizados usando o pacote 'general'
;; Licen√ßa: MIT
;;
;;; Commentary:
;;; Este arquivo define uma s√©rie de atalhos de teclado personalizados
;;; para o Emacs, inspirados no estilo Doom Emacs, utilizando o pacote
;;; 'general' para facilitar a cria√ß√£o e organiza√ß√£o dos keybindings.
;;;
;;; Code:
;;; ---------------------------------------------------------

;; Garante que o general esteja carregado
(require 'general)

;; ---------------------------------------------------------
;; DEFINI«√O DA TECLA LÕDER (SPC)
;; ---------------------------------------------------------
(general-create-definer leonam/leader-keys
  :states '(normal visual insert emacs motion)
  :keymaps 'override
  :prefix "SPC"
  :global-prefix "C-SPC")

;; ---------------------------------------------------------
;; MAPA GERAL (DOOM MIMIC)
;; ---------------------------------------------------------
(leonam/leader-keys
  ;; --- Top Level ---
  "SPC" '(execute-extended-command :which-key "M-x")     ; SPC SPC
  "."   '(find-file :which-key "Find file")              ; SPC .
  ","   '(switch-to-buffer :which-key "Switch buffer")   ; SPC ,
  ":"   '(eval-expression :which-key "Eval expression")  ; SPC :
  "RET" '(bookmark-jump :which-key "Jump to bookmark")   ; SPC ENTER
  "u"   '(universal-argument :which-key "Universal arg") ; SPC u

  ;; --- q: Quit/Session (Agora no lugar certo!) ---
  "q"   '(:ignore t :which-key "quit")
  "qq"  '(save-buffers-kill-terminal :which-key "Quit")
  "qR"  '(restart-emacs :which-key "Restart Emacs")
  "qd"  '((lambda () 
            (interactive) 
            (let ((restart-emacs-arguments '("--debug-init"))) 
              (restart-emacs))) 
          :which-key "Restart with Debug")

  ;; --- b: Buffers ---
  "b"   '(:ignore t :which-key "buffer")
  "bb"  '(switch-to-buffer :which-key "Switch buffer")
  "bk"  '(kill-current-buffer :which-key "Kill buffer")
  "bi"  '(ibuffer :which-key "Ibuffer")
  "bn"  '(next-buffer :which-key "Next buffer")
  "bp"  '(previous-buffer :which-key "Previous buffer")
  "bN"  '(clone-buffer :which-key "New empty buffer")
  "bs"  '(save-buffer :which-key "Save buffer")
  "bS"  '(save-some-buffers :which-key "Save all buffers")

  ;; --- f: Files ---
  "f"   '(:ignore t :which-key "file")
  "ff"  '(find-file :which-key "Find file")
  "fr"  '(consult-recent-file :which-key "Recent files")
  "fs"  '(save-buffer :which-key "Save file")
  "fS"  '(write-file :which-key "Save as...")
  "fp"  '((lambda () (interactive) (find-file (concat user-emacs-directory "init.el"))) :which-key "Open init.el")
  "fk"  '((lambda () (interactive) (find-file (concat user-emacs-directory "keybindings.el"))) :which-key "Open keybindings.el")

  ;; --- w: Window (Gerenciamento de Janelas) ---
  "w"   '(:ignore t :which-key "window")
  "ww"  '(evil-window-next :which-key "Next window")       ; Cicla entre janelas
  "wq"  '(evil-quit :which-key "Close window")             ; Fecha janela
  "wv"  '(evil-window-vsplit :which-key "Split vertical")  ; Divide na vertical
  "ws"  '(evil-window-split :which-key "Split horizontal") ; Divide na horizontal
  "wc"  '(delete-window :which-key "Delete window")        ; Deleta a janela atual
  "wo"  '(delete-other-windows :which-key "Maximize window"); Fecha as outras
  "w="  '(balance-windows :which-key "Balance windows")    ; Iguala tamanhos
  "wh"  '(evil-window-left :which-key "Focus left")
  "wj"  '(evil-window-down :which-key "Focus down")
  "wk"  '(evil-window-up :which-key "Focus up")
  "wl"  '(evil-window-right :which-key "Focus right")

  ;; --- p: Project (Projectile) ---
  "p"   '(:ignore t :which-key "project")
  "pp"  '(projectile-switch-project :which-key "Switch project")
  "pf"  '(projectile-find-file :which-key "Find file in project")
  "pr"  '(projectile-recentf :which-key "Recent project files")
  "pk"  '(projectile-kill-buffers :which-key "Kill project buffers")
  "ps"  '(projectile-switch-to-buffer :which-key "Project buffer")

  ;; --- g: Git (Magit) ---
  "g"   '(:ignore t :which-key "git")
  "gg"  '(magit-status :which-key "Magit status")
  "gc"  '(magit-clone :which-key "Clone repo")
  "gB"  '(magit-blame-addition :which-key "Blame line")
  "gd"  '(magit-diff-uncached :which-key "Diff buffer")

  ;; --- c: Code (LSP) ---
  "c"   '(:ignore t :which-key "code")
  "ca"  '(lsp-execute-code-action :which-key "Code action")
  "cd"  '(lsp-find-definition :which-key "Jump to definition")
  "cD"  '(lsp-find-references :which-key "Jump to references")
  "cr"  '(lsp-rename :which-key "Rename symbol")
  "cf"  '(apheleia-format-buffer :which-key "Format buffer")
  "ce"  '(lsp-treemacs-errors-list :which-key "List errors")

  ;; --- o: Open (AplicaÁıes) ---
  "o"   '(:ignore t :which-key "open")
  "oa"  '(org-agenda :which-key "Agenda")
  "op"  '(neotree-toggle :which-key "Project sidebar")
  "ot"  '(eshell :which-key "Terminal (Eshell)")

  ;; --- t: Toggle (Ligar/Desligar) ---
  "t"   '(:ignore t :which-key "toggle")
  "tt"  '(visual-line-mode :which-key "Truncate lines")
  "tl"  '(display-line-numbers-mode :which-key "Line numbers")
  "tf"  '(global-treesit-auto-mode :which-key "Treesitter")
  "tz"  '(writeroom-mode :which-key "Zen mode")

  ;; --- h: Help ---
  "h"   '(:ignore t :which-key "help")
  "hf"  '(describe-function :which-key "Describe function")
  "hv"  '(describe-variable :which-key "Describe variable")
  "hk"  '(describe-key :which-key "Describe key")
  "hr"  '((lambda () (interactive) (load-file user-init-file)) :which-key "Reload init.el"))
  ;; ^ O parÍnteses de fechamento deve ficar AQUI, depois de TUDO.

(provide 'keybindings)
