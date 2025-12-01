;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(if (eq system-type 'windows-nt)
    (progn
      ;; Configurações para Windows
      (setq doom-font (font-spec :family "SauceCodePro NF" :size 16 :weight 'medium)
            doom-variable-pitch-font (font-spec :family "SauceCodePro NF" :size 16)))
  (progn
    ;; Configurações para outros sistemas (Linux, macOS, etc.)
    (setq doom-font (font-spec :family "Maple Mono NF" :size 16 :weight 'medium)
          doom-variable-pitch-font (font-spec :family "Maple Mono NF" :size 16))))
;; Sistema e Fontes:1 ends here

;; [[file:config.org::*Tema, UI e Aparência][Tema, UI e Aparência:1]]
(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)
(setq user-full-name "bashln"
      user-mail-address "lpdmonteiro+doom@gmail.com")
;; Tema, UI e Aparência:1 ends here

;; [[file:config.org::*Org Mode — Configuração Geral][Org Mode — Configuração Geral:1]]
(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)

(after! org
  (setq org-directory "~/org/"
        org-modern-table t
        org-modern-table-vertical 1
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        ;; org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦))
        org-log-done 'time
        org-hide-emphasis-markers t
        org-table-convert-region-max-lines 20000
        org-todo-keywords
        '((sequence
           "TODO(t)"
           "BLOG(b)"
           "GYM(g)"
           "PROJ(p)"
           "VIDEO(v)"
           "WAIT(w)"
           "|"
           "DONE(d)"
           "CANCELLED(c)"))))

(after! doom-themes
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
    '(org-document-title  :height 1.8 :bold t :underline nil)))
;; Org Mode — Configuração Geral:1 ends here

;; [[file:config.org::*Org Mode — Org Superstar / Org Modern][Org Mode — Org Superstar / Org Modern:1]]
(add-hook 'org-mode-hook #'hl-todo-mode)
;; (add-hook 'org-mode-hook #'org-superstar-mode)

(after! org-modern
  (setq org-modern-star '("◉" "●" "○" "◆" "●" "○" "◆")
        org-modern-hide-stars t))
;; Org Mode — Org Superstar / Org Modern:1 ends here

;; [[file:config.org::*Org Mode — Org-Auto-Tangle][Org Mode — Org-Auto-Tangle:1]]
(use-package! org-auto-tangle
  :config
  (setq org-auto-tangle-default t)
  (add-hook 'org-mode-hook #'org-auto-tangle-mode))

(defun leonam/insert-auto-tangle-tag ()
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
      "i a" #'leonam/insert-auto-tangle-tag)
;; Org Mode — Org-Auto-Tangle:1 ends here

;; [[file:config.org::*Org Mode — Agenda][Org Mode — Agenda:1]]
(setq org-directory "~/org"
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      org-agenda-files (list (expand-file-name "tasks.org" org-directory)
                             (expand-file-name "work.org"  org-directory)
                             (expand-file-name "study.org" org-directory))
      org-ellipsis " ⤵"
      org-log-done 'time
      org-log-into-drawer t)

(setq org-agenda-start-on-weekday nil
      org-agenda-span 1
      org-agenda-time-grid '((daily today require-timed)
                             (800 900 1000 1100 1200 1400 1600 1800 2000))
      org-agenda-use-time-grid t
      org-agenda-show-future-repeats 'next
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t)

(setq org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-12t% s")
        (todo   . " %i %-12:c [%-3e] ")
        (tags   . " %i %-12:c")
        (search . " %i %-12:c")))

(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-agenda-custom-commands
      '(("w" "Workday (hoje)"
         ((agenda "" ((org-agenda-span 1)))
          (todo "IN-PROGRESS")
          (todo "TODO"))
         ((org-agenda-overriding-header "⚡ Dia de trabalho")))))

(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "🔥 Urgente"  :deadline today :priority "A")
          (:name "🗓 Hoje"     :scheduled today)
          (:name "⏳ Em breve" :deadline future)
          (:name "📦 Projetos" :tag "project")
          (:name "✅ Concluídas" :todo "DONE" :order 99))))
;; Org Mode — Agenda:1 ends here

;; [[file:config.org::*Org Mode — Capture Templates][Org Mode — Capture Templates:1]]
(with-eval-after-load 'org
  (add-to-list 'org-modules 'org-habit))

(setq org-habit-graph-column 60
      org-habit-preceding-days 14
      org-habit-following-days 7)

(setq org-clock-persist 'history
      org-clock-report-include-clocking-task t
      org-duration-format 'h:mm)

(org-clock-persistence-insinuate)
;; Org Mode — Capture Templates:1 ends here

;; [[file:config.org::*LSP / Eglot / LSP Mode][LSP / Eglot / LSP Mode:1]]
(after! lsp-mode
  (setq lsp-go-use-gofumpt t))

(after! lsp-mode
  (setq lsp-go-analyses '((nilness . t)
                          (shadow . t)
                          (unusedparams . t)
                          (unusedwrite . t)
                          (useany . t)
                          (unusedvariable . t))))

(after! eglot
  (map! :map eglot-mode-map
        :localleader
        :desc "Eglot Quick fix"
        "c q" #'eglot-code-action-quickfix))
;; LSP / Eglot / LSP Mode:1 ends here

;; [[file:config.org::*Copilot][Copilot:1]]
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
  (setq copilot-indent-offset-warning-disable t))
;; Copilot:1 ends here

;; [[file:config.org::*JavaScript / TypeScript / TSX][JavaScript / TypeScript / TSX:1]]
(add-to-list 'major-mode-remap-alist '(js-mode . js2-mode))

(after! js2-mode
  (setq js2-basic-offset 2
        js2-bounce-indent-p nil))

(use-package! treesit-auto
  :custom
  (treesit-auto-install 'prompt))

(apheleia-global-mode +1)

(after! js2-mode
  (setq js2-strict-missing-semi-warning nil))

;; (after! apheleia
;;   (setf (alist-get 'prettier apheleia-formatters)
;;         '("npx" "prettier" "--config" "~/.config/prettier/.prettierrc" "--stdin-filepath" filepath))
;;   (dolist (m '(js2-mode typescript-mode tsx-ts-mode json-mode))
;;     (setf (alist-get m apheleia-mode-alist) '(prettier))))
;; JavaScript / TypeScript / TSX:1 ends here

;; [[file:config.org::*Markdown][Markdown:1]]
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(defun leonam/toggle-markdown-view-mode ()
  (interactive)
  (if (eq major-mode 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))
;; Markdown:1 ends here

;; [[file:config.org::*Miscelânea][Miscelânea:1]]
(setq confirm-kill-emacs nil)        
(let ((lfile (concat doom-local-dir "straight/repos/transient/lisp/transient.el")))
  (if (file-exists-p lfile)
      (load lfile)))

(setq-default tab-width 2)

(after! projectile
  (setq projectile-project-root-files-bottom-up
        (remove ".git" projectile-project-root-files-bottom-up)))
;; Miscelânea:1 ends here

;; -----------------------------
;; Vertico stack moderna para Doom
;; -----------------------------

;; Marginalia — anotação de candidatos
(use-package! marginalia
  :after vertico
  :init (marginalia-mode))

;; Orderless — fuzzy matching poderoso
(use-package! orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

;; Consult — comandos inteligentes
(use-package! consult
  :after vertico
  :bind (("C-s" . consult-line)
         ("C-c C-r" . consult-recent-file)
         ("C-c b" . consult-buffer)
         ("M-y" . consult-yank-pop)))

;; Embark — menu de ações contextuais
(use-package! embark
  :bind
  (("C-." . embark-act)         ;; o "menu secreto"
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package! embark-consult
  :after (embark consult))

;; Corfu — autocompletar suave tipo nvim-cmp
(use-package! corfu
  :config
  (global-corfu-mode)
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 1
        corfu-cycle t))

;; Para terminais
(use-package! corfu-terminal
  :when (not (display-graphic-p))
  :config (corfu-terminal-mode))
