;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; system-type is a variable defined in `C source code'.
;; Its value is darwin

;; Documentation:
;; Value is symbol indicating type of operating system you are using.
;; Special values:
;;   `gnu'         compiled for a GNU Hurd system.
;;   `gnu/linux'   compiled for a GNU/Linux system.
;;   `darwin'      compiled for Darwin (GNU-Darwin, Mac OS X, ...).
;;   `ms-dos'      compiled as an MS-DOS application.
;;   `windows-nt'  compiled as a native W32 application.
;;   `cygwin'      compiled using the Cygwin library.
;; Anything else indicates some sort of Unix system.

(if (eq system-type 'windows-nt)
    (progn
      ;; Configurações para Windows
      (setq doom-font (font-spec :family "Terminess Nerd Font" :size 19 :weight 'medium)
            doom-variable-pitch-font (font-spec :family "Terminess Nerd Font" :size 19)))
  ;; (setq doom-font (font-spec :family "CaskaydiaCove NF" :size 17 :weight 'semi-light)
  ;;        doom-variable-pitch-font (font-spec :family "CaskaydiaCove NF" :size 18)))
  (progn
    ;; Configurações para outros sistemas (Linux, macOS, etc.)
    (setq doom-font (font-spec :family "Iosevka Nerd Font" :size 18 :weight 'medium)
          doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 20))))
;; (setq doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 17 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size 18))))

;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-moonlight)
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'macchiato) ; or 'frappe 'latte, 'macchiato, or 'mocha
(load-theme 'catppuccin t)
;; (require 'kaolin-themes)
;; (load-theme 'kaolin-valley-dark t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.

(setq user-full-name "bashln"
      user-mail-address "lpdmonteiro+doom@gmail.com")

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

;; source: https://nayak.io/posts/golang-development-doom-emacs/
;; golang formatting set up
;; use gofumpt
(after! lsp-mode
  (setq  lsp-go-use-gofumpt t)
  )

;; enable all analyzers; not done by default
(after! lsp-mode
  (setq  lsp-go-analyses '((nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  )

(setq confirm-kill-emacs nil)        ;; Don't confirm on exit
;; (setq initial-buffer-choice 'eshell) ;; Eshell is initial buffer

;; Org base
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(add-hook 'org-mode-hook #'hl-todo-mode)

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)
(after! org
  (setq org-directory "~/org/"
        org-modern-table t
        org-modern-table-vertical 1
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        ;; org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
        ;; '(("google" . "http://www.google.com/search?q=")
        ;;   ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
        ;;   ("ddg" . "https://duckduckgo.com/?q=")
        ;;   ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
        '((sequence
           "TODO(t)"           ; A task that is ready to be tackled
           "BLOG(b)"           ; Blog writing assignments
           "GYM(g)"            ; Things to accomplish at the gym
           "PROJ(p)"           ; A project that contains other tasks
           "VIDEO(v)"          ; Video assignments
           "WAIT(w)"           ; Something is holding up this task
           "|"                 ; The pipe necessary to separate "active" states and "inactive" states
           "DONE(d)"           ; Task has been completed
           "CANCELLED(c)" )))) ; Task has been cancelled

;; Org-auto-tangle
;; org-auto-tangle allows you to add the option #+auto_tangle: t in your Org file so that it automatically tangles when you save the document.  I have made adding this to your file even easier by creating a function ‘bashln/insert-auto-tangle-tag’ and setting it to a keybinding ‘SPC i a’.
(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun bashln/insert-auto-tangle-tag ()
  "Insert '#+auto_tangle: t' at point or top of buffer in a literate config."
  (interactive)
  (if (derived-mode-p 'org-mode)
      (progn
        (evil-org-open-below 1)
        (insert "#+auto_tangle: t\n")
        (evil-force-normal-state))
    (message "Not in an Org buffer!")))

(map! :leader
      :desc "Insert auto_tangle tag"
      "i a" #'bashln/insert-auto-tangle-tag)


;; This sets the font size for each Org header level.  Having variable font sizes in an Org outline makes it visually appealing and more readable.
(custom-theme-set-faces!
  'doom-one
  '(org-level-8 :inherit outline-3 :height 1.0)
  '(org-level-7 :inherit outline-3 :height 1.0)
  '(org-level-6 :inherit outline-3 :height 1.1)
  '(org-level-5 :inherit outline-3 :height 1.2)
  '(org-level-4 :inherit outline-3 :height 1.3)
  '(org-level-3 :inherit outline-3 :height 1.4)
  '(org-level-2 :inherit outline-2 :height 1.5)
  '(org-level-1 :inherit outline-1 :height 1.6)
  '(org-document-title  :height 1.8 :bold t :underline nil))

;; Markdown Mode
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(defun bashln/toggle-markdown-view-mode ()
  ;; "Toggle between `markdown-mode' and `markdown-view-mode'."
  (interactive)
  (if (eq major-mode 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))

;; workaround the error
;; condition-case: Error in a Doom startup hook: doom-first-file-hook, global-git-commit-mode, (void-function transient--set-layout)

(let ((lfile (concat doom-local-dir "straight/repos/transient/lisp/transient.el")))
  (if (file-exists-p lfile)
      (load lfile)))

;; Copilot.el

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("C-n" . 'copilot-next-completion)
              ("C-p" . 'copilot-previous-completion))

  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(clojure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  :init
  (setq copilot-indent-offset-warning-disable t)
  )

(setq-default tab-width 2)

;; Remove js2-mode from auto-mode-alist for .js files and replace it with js2-mode

(add-to-list 'major-mode-remap-alist '(js-mode . js2-mode))
(after! js2-mode
  (setq js2-basic-offset 2     
        js2-bounce-indent-p nil))

;; Prettier como formatador via Apheleia
(after! apheleia
  (setf (alist-get 'prettier apheleia-formatters)
        '("npx" "prettier" "--config" "~/.config/prettier/.prettierrc" "--stdin-filepath" filepath))
  (dolist (m '(js2-mode typescript-mode tsx-ts-mode json-mode))
    (setf (alist-get m apheleia-mode-alist) '(prettier))))


;; Tree Sitter
;; (setq +tree-sitter-hl-enabled-modes t)
;; (after! tree-sitter
;;         (global-tree-sitter-mode)
;;         (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! treesit-auto
  :custom
  ;; Pergunta antes de instalar grammar
  (treesit-auto-install 'prompt)
  :config
  ;; Por enquanto, só quero tree-sitter nessas linguagens
  (setq treesit-auto-langs '(tsx typescript))

  ;; Usa essa lista pra configurar auto-mode-alist
  (treesit-auto-add-to-auto-mode-alist)

  ;; Liga o modo global de decisão entre *-mode e *-ts-mode
  (global-treesit-auto-mode))


(add-hook 'js2-mode-hook #'apheleia-mode)  ;; formatar ao salvar nesse modo
;; ou globalmente:
(apheleia-global-mode +1)

;; Já que você usa js2-mode, silencie o aviso de ponto-e-vírgula se quiser:
(after! js2-mode
  (setq js2-strict-missing-semi-warning nil))

;; LSP continua com Eglot:
;; (setq eglot-format-on-save nil) ; deixa a formatação pro Prettier


