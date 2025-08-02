;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

;; (setq doom-font (font-spec :family "Iosevka NFM" :size 16)
(setq doom-font (font-spec :family "SpaceMono Nerd Font" :size 17)
      doom-variable-pitch-font (font-spec :family "SpaceMono Nerd Font" :size 17))

;; (setq-default line-spacing 2)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-one)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq confirm-kill-emacs nil)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuracao de Clipboard                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(require 'simpleclip)
(simpleclip-mode 1)
(move-text-default-bindings)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuracao de linguagem                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuracao de atalhos(which-key)                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Configurações adicionais (mantidas da sua configuração original)
(use-package which-key
  :init (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-allow-imprecise-window-fit nil
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-separator " \u2192 "))
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuracao de nerd icons (for modeline)                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuracao de 'modes' para programacao                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)) ;;To ensure Emacs always starts with js2-mode for .js files
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode)) ;;To ensure Emacs always starts with js2-mode for .js files
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) ;;To ensure Emacs always starts with js2-mode for .js files

;; ---
;; ## Configurações para integração de LSP, Corfu e Snippets (Yasnippet)
;; ---
(after! lsp-mode
  ;; Habilita yasnippet para todos os modos que o lsp-mode ativa
  (add-hook 'lsp-mode-hook #'yas-minor-mode))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)


(after! yasnippet
  ;; Carrega snippets para linguagens específicas quando o modo é ativado
  ;; O Doom já faz isso automaticamente para os módulos que você habilitou,
  ;; mas é bom para snippets personalizados.
  (yas-reload-all)
  )

;; --- Configurações LSP-mode ---

;; Certifique-se de que o lsp-mode está instalado via M-x package-install RET lsp-mode RET
(require 'lsp-mode)

;; Ativar o LSP para os modos relevantes (TypeScript, JavaScript, JSON)
(add-hook 'typescript-mode-hook #'lsp)
;; (add-hook 'js-mode-hook #'lsp)
;; (add-hook 'json-mode-hook #'lsp) ;; Útil para arquivos JSON de configuração

;; (setq lsp-log-io t) ;; Descomente esta linha para depurar o LSP-mode, útil se algo não estiver funcionando

;; Opcional: Configurar autocompletar com company-mode
;; Certifique-se de que o company-lsp está instalado via M-x package-install RET company-lsp RET
(require 'company-lsp)
(add-hook 'after-init-hook #'global-company-mode) ;; Ativa o company-mode globalmente
(add-hook 'lsp-mode-hook #'company-lsp-init) ;; Integra company-mode com lsp-mode
(setq company-idle-delay 0.1) ;; Delay para o autocompletar aparecer (em segundos)
(setq company-minimum-prefix-length 1) ;; Número mínimo de caracteres para iniciar o autocompletar

;; Opcional: Configuração de depuração com dap-mode (requer instalação via package-install)
;; (require 'dap-mode)
;; (dap-mode-setup)

;; Opcional: Configurações para lsp-ui, que fornece a interface de usuário visual (popups de documentação, etc.)
;; Certifique-se de que o lsp-ui e all-the-icons estão instalados via package-install
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references))
  :config
  ;;   ;; Posição da documentação: 'at-point' (próximo ao cursor), 'pop-up' ou 'childframe'
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.5 ;; Delay para o popup da documentação aparecer
        lsp-ui-doc-show-with-mouse nil ;; Não mostrar ao passar o mouse, a menos que configurado
        lsp-ui-sideline-show-code-actions t ;; Mostrar ações de código na barra lateral
        lsp-ui-sideline-show-hover t ;; Mostrar informações de hover na barra lateral
        lsp-ui-sideline-delay 0.5))


(setq lsp-inlay-hint-enable t)
(add-hook 'lsp-mode-hook #'lsp-inlay-hints-mode)
(setq lsp-javascript-display-inlay-hints t)
(setq lsp-typescript-display-inlay-hints t)

;; Para JavaScript/TypeScript, certifique-se de que o Yasnippet
;; tem snippets para esses modos. O Doom já deve fornecer,
;; mas você pode adicionar os seus próprios em ~/.doom.d/snippets/javascript-mode/
;; ou ~/.doom.d/snippets/js2-mode/.

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("<backtab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuracao de atalhos(keymaps)                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Keybindings com map!
(map! :leader
      :desc "Counsel M-x" "SPC" #'counsel-M-x
      :desc "Find file" "." #'find-file
      :desc "Perspective" "=" #'perspective-map
      :desc "Comment lines" "TAB TAB" #'comment-line
      :desc "Universal argument" "u" #'universal-argument)

;; Buffer/bookmark bindings
(map! :leader
      :prefix "b"
      :desc "Switch to buffer" "b" #'switch-to-buffer
      :desc "Create indirect buffer copy" "c" #'clone-indirect-buffer
      :desc "Clone indirect buffer other window" "C" #'clone-indirect-buffer-other-window
      :desc "Delete bookmark" "d" #'bookmark-delete
      :desc "Ibuffer" "i" #'ibuffer
      :desc "Kill current buffer" "k" #'kill-current-buffer
      :desc "Kill multiple buffers" "K" #'kill-some-buffers
      :desc "List bookmarks" "l" #'list-bookmarks
      :desc "Set bookmark" "m" #'bookmark-set
      :desc "Next buffer" "n" #'next-buffer
      :desc "Previous buffer" "p" #'previous-buffer
      :desc "Reload buffer" "r" #'revert-buffer
      :desc "Rename buffer" "R" #'rename-buffer
      :desc "Save buffer" "s" #'basic-save-buffer
      :desc "Save multiple buffers" "S" #'save-some-buffers
      :desc "Save bookmarks" "w" #'bookmark-save)

;; Dired bindings
(map! :leader
      :prefix "d"
      :desc "Open maisPraTi folder" "A" (lambda () (interactive) (neotree-dir "/run/media/lm/dev/maisPraTi/"))
      :desc "Open dired" "d" #'dired
      :desc "Open doom folder" "D" (lambda () (interactive) (neotree-dir "~/dotfiles/.config/doom/"))
      :desc "Dired jump" "j" #'dired-jump
      :desc "Open neotree" "n" #'neotree-dir
      :desc "Peep-dired" "p" #'peep-dired
      :desc "Open teste producao" "P" (lambda () (interactive) (dired "i:/Teste_Producao/")))

;; Eshell/Evaluate bindings
(map! :leader
      :prefix "e"
      :desc "Evaluate buffer" "b" #'eval-buffer
      :desc "Evaluate defun" "d" #'eval-defun
      :desc "Evaluate expression" "e" #'eval-expression
      :desc "Eshell history" "h" #'counsel-esh-history
      :desc "Evaluate last sexp" "l" #'eval-last-sexp
      :desc "Evaluate region" "r" #'eval-region
      :desc "Reload EWW" "R" #'eww-reload
      :desc "Eshell" "s" #'eshell
      :desc "EWW browser" "w" #'eww)

;; File bindings
(map! :leader
      :prefix "f"
      :desc "Open alacritty config" "a" (lambda () (interactive) (find-file "~/dotfiles/.config/alacritty/alacritty.toml"))
      :desc "Open emacs config" "c" (lambda () (interactive) (find-file "~/dotfiles/.config/doom/config.el"))
      :desc "Open user-emacs-directory" "e" (lambda () (interactive) (dired "~/dotfiles/.config/doom/custom.el"))
      :desc "Find grep dired" "d" #'find-grep-dired
      :desc "Open fish config" "f" (lambda () (interactive) (find-file "~/dotfiles/.config/fish/config.fish"))
      :desc "Search current file" "g" #'counsel-grep-or-swiper
      :desc "Open hyprland config" "h" (lambda () (interactive) (find-file "~/dotfiles/.config/hypr/hyprland.conf"))
      :desc "Open init.el" "i" (lambda () (interactive) (find-file "~/dotfiles/.doom.d/init.el"))
      :desc "Jump to file" "j" #'counsel-file-jump
      :desc "Open kitty config" "k" (lambda () (interactive) (find-file "~/dotfiles/.config/kitty/kitty.conf"))
      :desc "Locate file" "l" #'counsel-locate
      :desc "Open qtile config" "q" (lambda () (interactive) (find-file "~/dotfiles/.config/qtile/config.py"))
      :desc "Find recent files" "r" #'counsel-recentf
      :desc "Sudo find file" "u" #'sudo-edit-find-file
      :desc "Sudo edit file" "U" #'sudo-edit
      :desc "Open zshrc" "z" (lambda () (interactive) (find-file "~/dotfiles/.zshrc")))
:desc "Open emacs config windows" "w" (lambda () (interactive) (find-file "~/.doom.d/config.el"))

;; Git bindings
(map! :leader
      :prefix "g"
      :desc "Magit dispatch" "/" #'magit-dispatch
      :desc "Magit file dispatch" "." #'magit-file-dispatch
      :desc "Switch branch" "b" #'magit-branch-checkout
      :desc "Create branch and checkout" "c b" #'magit-branch-and-checkout
      :desc "Create commit" "c c" #'magit-commit-create
      :desc "Create fixup commit" "c f" #'magit-commit-fixup
      :desc "Clone repo" "C" #'magit-clone
      :desc "Show commit" "f c" #'magit-show-commit
      :desc "Magit find file" "f f" #'magit-find-file
      :desc "Find gitconfig" "f g" #'magit-find-git-config-file
      :desc "Git fetch" "F" #'magit-fetch
      :desc "Magit status" "g" #'magit-status
      :desc "Initialize repo" "i" #'magit-init
      :desc "Buffer log" "l" #'magit-log-buffer-file
      :desc "Revert file" "r" #'vc-revert
      :desc "Stage file" "s" #'magit-stage-file
      :desc "Time machine" "t" #'git-timemachine
      :desc "Unstage file" "u" #'magit-unstage-file)

;; Help bindings
(map! :leader
      :prefix "h"
      :desc "Apropos" "a" #'counsel-apropos
      :desc "Describe bindings" "b" #'describe-bindings
      :desc "Describe char" "c" #'describe-char
      :desc "About Emacs" "d a" #'about-emacs
      :desc "View debugging" "d d" #'view-emacs-debugging
      :desc "View FAQ" "d f" #'view-emacs-FAQ
      :desc "Emacs manual" "d m" #'info-emacs-manual
      :desc "View news" "d n" #'view-emacs-news
      :desc "Describe distribution" "d o" #'describe-distribution
      :desc "View problems" "d p" #'view-emacs-problems
      :desc "View todo" "d t" #'view-emacs-todo
      :desc "Describe no warranty" "d w" #'describe-no-warranty
      :desc "View messages" "e" #'view-echo-area-messages
      :desc "Describe function" "f" #'describe-function
      :desc "Describe face" "F" #'describe-face
      :desc "Describe GNU Project" "g" #'describe-gnu-project
      :desc "Info" "i" #'info
      :desc "Describe input method" "I" #'describe-input-method
      :desc "Describe key" "k" #'describe-key
      :desc "View keystrokes" "l" #'view-lossage
      :desc "Describe language" "L" #'describe-language-environment
      :desc "Describe mode" "m" #'describe-mode
      :desc "Reload Doom config" "r r" #'doom/reload-config
      :desc "Reload config windows" "r w" (lambda () (interactive) (load-file "~/doom/init.el"))
      :desc "Load theme" "t" #'load-theme
      :desc "Describe variable" "v" #'describe-variable
      :desc "Where is" "w" #'where-is
      :desc "Describe command" "x" #'describe-command)

;; Org bindings
(map! :leader
      :prefix "m"
      :desc "Org agenda" "a" #'org-agenda
      :desc "Org export" "e" #'org-export-dispatch
      :desc "Toggle item" "i" #'org-toggle-item
      :desc "Org todo" "t" #'org-todo
      :desc "Babel tangle" "B" #'org-babel-tangle
      :desc "Todo list" "T" #'org-todo-list
      :desc "Insert hline" "b -" #'org-table-insert-hline
      :desc "Time stamp" "d t" #'org-time-stamp
      :desc "move line up" "u" #'move-line-up
      :desc "move line down" "d" #'move-line-down
      :desc "duplicate line" "D" #'duplicate-dwim)

;; Open bindings
(map! :leader
      :prefix "o"
      :desc "Dashboard" "d" #'dashboard-open
      :desc "Elfeed" "e" #'elfeed
      :desc "New frame" "f" #'make-frame
      :desc "Select frame" "F" #'select-frame-by-name)

;; Projectile bindings (mantido como estava)
(map! :leader
      :desc "Projectile" "p" #'projectile-command-map)

;; Search bindings
(map! :leader
      :prefix "s"
      :desc "Dictionary search" "d" #'dictionary-search
      :desc "Man pages" "m" #'man
      :desc "TLDR" "t" #'tldr
      :desc "Woman" "w" #'woman)

;; Toggle bindings
(map! :leader
      :prefix "t"
      :desc "Toggle neotree dir" "d" #'neotree-dir
      :desc "Toggle eshell" "e" #'eshell-toggle
      :desc "Toggle flycheck" "f" #'flycheck-mode
      :desc "Toggle line numbers" "l" #'display-line-numbers-mode
      :desc "Toggle neotree" "n" #'neotree-toggle
      :desc "Toggle org mode" "o" #'org-mode
      :desc "Toggle rainbow" "r" #'rainbow-mode
      :desc "Toggle truncate lines" "t" #'visual-line-mode
      :desc "Toggle vterm" "v" #'vterm-toggle
      :desc "Package install" "p" #'package-install)

;; Window bindings
(map! :leader
      :prefix "w"
      :desc "Close window" "c" #'evil-window-delete
      :desc "New window" "n" #'evil-window-new
      :desc "Split window" "s" #'evil-window-split
      :desc "Vsplit window" "v" #'evil-window-vsplit
      :desc "Window left" "h" #'evil-window-left
      :desc "Window down" "j" #'evil-window-down
      :desc "Window up" "k" #'evil-window-up
      :desc "Window right" "l" #'evil-window-right
      :desc "Next window" "w" #'evil-window-next
      :desc "Buffer move left" "H" #'buf-move-left
      :desc "Buffer move down" "J" #'buf-move-down
      :desc "Buffer move up" "K" #'buf-move-up
      :desc "Buffer move right" "L" #'buf-move-right)
