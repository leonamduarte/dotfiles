;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Leonamsh"
      user-mail-address "lpdmonteiro@gmail.com")

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
(setq doom-font (font-spec :family "Maple Mono NF" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Maple Mono NF" :size 15))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'macchiato) ; or 'frappe 'latte, 'macchiato, or 'mocha
(load-theme 'catppuccin t)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/Volumes/mememe/Org/")


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
;; automatically organize imports
(add-hook 'go-mode-hook #'lsp-deferred)
;; Make sure you don't have other goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; enable all analyzers; not done by default
(after! lsp-mode
  (setq  lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  )
;; use system clipboard
;; (require 'pbcopy)
;; (turn-on-pbcopy)

;;; === DT-style em Doom: Dired turbo ===
(after! dired
  (add-hook 'dired-mode-hook #'all-the-icons-dired-mode)
  (use-package! dired-open
    :after dired
    :config
    (setq dired-open-extensions
          '(("gif" . "sxiv") ("jpg" . "sxiv") ("jpeg" . "sxiv") ("png" . "sxiv")
            ("mkv" . "mpv") ("mp4" . "mpv") ("webm" . "mpv"))))
  (use-package! peep-dired
    :after dired
    :commands (peep-dired)
    :init (add-hook 'peep-dired-hook #'evil-normalize-keymaps)
    :config
    (map! :map dired-mode-map
          :n "h" #'dired-up-directory
          :n "l" #'dired-find-file
          :n "SPC" #'peep-dired))
  (setq dired-listing-switches "-alh --group-directories-first"))

;;; === Git time machine ===
(map! :leader :desc "Git time machine" "g t" #'git-timemachine)

;;; === Mover buffers entre janelas ===
(use-package! buffer-move :commands (buf-move-up buf-move-down buf-move-left buf-move-right))
(map! :n "C-S-<left>"  #'buf-move-left
      :n "C-S-<right>" #'buf-move-right
      :n "C-S-<up>"    #'buf-move-up
      :n "C-S-<down>"  #'buf-move-down)

;;; === Backups fora dos projetos ===
(setq backup-directory-alist '((".*" . "~/.local/share/Trash/files")))

;;; === (Opcional) Neotree ao estilo DT ===
;; (use-package! neotree
;;   :commands (neotree-toggle neotree-projectile-action)
;;   :config
;;   (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
;;   (setq neo-smart-open t))
;; (map! :leader :desc "Neotree" "o n" #'neotree-toggle)

