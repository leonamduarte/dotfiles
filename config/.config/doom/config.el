;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; --- FIX: TRANSIENT ---
(let ((lfile (concat doom-local-dir "straight/repos/transient/lisp/transient.el")))
  (if (file-exists-p lfile) (load lfile)))

;; -------------------------------
;; 1. IDENTIDADE & SISTEMA
;; -------------------------------
(setq user-full-name "bashln"
      user-mail-address "lpdmonteiro+doom@gmail.com")

;; Fontes (Monospace & Variable Pitch)
(let ((font-family (if (eq system-type 'windows-nt)
                       "JetBrainsMono NF"
                     "CaskaydiaCove Nerd Font")))
  (setq doom-font (font-spec :family font-family :size 16)
        doom-variable-pitch-font (font-spec :family font-family :size 16)))

;; UI / Tema
(setq doom-theme 'doom-one)
;; (setq doom-theme 'catppuccin)
;; (setq catppuccin-flavor 'macchiato)
(setq display-line-numbers-type t
      confirm-kill-emacs nil)
(setq-default tab-width 2)

;; -------------------------------
;; 2. ORG MODE
;; -------------------------------

(after! org
  (setq org-default-notes-file (expand-file-name "inbox.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAIT(w)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)")))
  (add-to-list 'org-modules 'org-habit))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-table t
        org-modern-hide-stars t))

(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default t))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)

;; -------------------------------
;; 3. DESENVOLVIMENTO & LSP
;; -------------------------------

;; Tuning JS/TS
(after! js2-mode
  (setq js2-basic-offset 2
        js2-bounce-indent-p nil
        js2-strict-missing-semi-warning nil))

;; Typescript/Web defaults
(after! typescript-mode
  (setq typescript-indent-level 2))

(after! web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

;; Treesitter Auto Install
(use-package! treesit-auto
  :config (global-treesit-auto-mode))

;; Copilot - FIX: Não conflita com corfu
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ;; MUDANÇA: Use C-j ao invés de TAB para não conflitar com corfu
              ("<backtab>" . 'copilot-accept-completion))
  ;; ("C-M-TAB" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t)
  (add-to-list 'copilot-indentation-alist '(prog-mode 2)))

(use-package! kdl-mode
  :mode "\\.kdl\\'")

;; -------------------------------
;; 4. COMPLETION (Vertico/Corfu)
;; -------------------------------
(after! marginalia (marginalia-mode))

(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-quit-no-match 'separator  ;; FIX: Evita o erro de nil
        corfu-preselect 'prompt         ;; Não pré-seleciona primeira opção
        corfu-popupinfo-delay 0.5
        corfu-popupinfo-max-height 6)
  ;; IMPORTANTE: Garante que TAB funciona com corfu
  (map! :map corfu-map
        "TAB" #'corfu-next
        [tab] #'corfu-next
        "S-TAB" #'corfu-previous
        [backtab] #'corfu-previous))

(after! orderless
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

(map! :leader
      "b b" #'consult-buffer
      "f r" #'consult-recent-file)
(map! "C-." #'embark-act)

(after! eldoc
  (setq eldoc-echo-area-use-multiline-p nil
        eldoc-display-functions '(eldoc-display-in-echo-area)))

;; -------------------------------
;; 5. FORMATAÇÃO (ESTILO NEOVIM)
;; -------------------------------

;; 1. Desativa o 'mordomo' (ws-butler) que protege espaços
(setq ws-butler-mode nil)

;; 2. Configura Apheleia (Formatador Assíncrono)
;; (Removido: O módulo :format +onsave já configura isso de forma otimizada)

;; 3. Hooks de Limpeza Nuclear (Igual ao Nvim)
;; Garante remoção de espaços e nova linha no final SEMPRE.
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

;; 4. Prioridade de Formatação
(setq-hook! 'lua-mode-hook +format-with-lsp nil) ;; Usa stylua, não lua-lsp
(setq-hook! 'python-mode-hook +format-with-lsp nil) ;; Usa black/ruff, não pyright

;; -------------------------------
;; 6. LSP TUNING & BOOSTER (PERFORMANCE CRÍTICA)
;; -------------------------------

(after! lsp-mode
  ;; Configs Gerais
  (setq lsp-go-use-gofumpt t
        lsp-go-analyses '((nilness . t) (unusedparams . t) (unusedwrite . t)))

  ;; Tuning de Performance
  (setq lsp-use-plists t
        lsp-idle-delay 0.500
        lsp-log-io nil
        lsp-enable-file-watchers nil
        lsp-completion-provider :none  ;; FIX: Desativa completion do LSP, usa só corfu
        lsp-headerline-breadcrumb-enable nil ;; Desativa breadcrumbs (menos ruído visual/proc)
        +format-with-lsp nil)) ;; Desativa globalmente, confiamos no módulo :editor format

(after! lsp-eslint
  (setq lsp-eslint-enable t
        lsp-eslint-auto-fix-on-save nil
        lsp-eslint-run "onType"))

(after! lsp-sqls
  (setq lsp-sqls-workspace-config
        '((formatter
           (language "sql"
                     (indent 2)))
          (lint
           (colon true))
          (connections
           ())))
  (add-hook 'sql-mode-hook #'lsp-deferred))

;; Emacs LSP Booster Wrapper
(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))

(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)
             (not (file-remote-p default-directory))
             lsp-use-plists
             (not (functionp 'json-rpc-connection))
             (executable-find "emacs-lsp-booster"))
        (progn
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; Limites de I/O
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setenv "LSP_USE_PLISTS" "true")

;; -------------------------------
;; 7. EXTRA TOOLS
;; -------------------------------

;; Neotree
(map! :leader
      :desc "Toggle Neotree" "o n" #'neotree-toggle
      :desc "Neotree Directory" "o N" #'neotree-dir)

;; Grease
(use-package! grease
  :init
  (setq grease-sort-method 'type
        grease-show-hidden nil
        grease-preview-window-width 0.4)
  :config
  (map! :leader
        (:prefix ("o g" . "Grease")
         :desc "Toggle Grease"            "g" #'grease-toggle
         :desc "Open Grease (current)"    "o" #'grease-open
         :desc "Open at project root"     "h" #'grease-here)
        :desc "Toggle Grease like Oil.nvim" "-" #'grease-toggle))

;; fzf recursivo com fd
(map! :leader
      :desc "fzf search files" "s z" #'counsel-fzf)

;; Configurar fd como backend do fzf
(after! counsel
  (setq counsel-fzf-cmd "fd --type f --hidden --follow --exclude .git"))

;; Otimização de Garbage Collection (GCMH)
(use-package! gcmh
  :hook (after-init . gcmh-mode)
  :config
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024)))

;; Otimização de Scrolling
(setq fast-but-imprecise-scrolling t)

;; Personal Keybindings

;; Mover linha ou região usando ALT + J e ALT + K, similar ao comportamento do Neovim

(defun leo/move-line-up ()
  "Move the current line up by one."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun leo/move-line-down ()
  "Move the current line down by one."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun leo/move-text-up ()
  "Move region up, or current line up if no region is active."
  (interactive)
  (if (use-region-p)
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (delete-and-extract-region beg end)))
        ;; vai pra linha anterior e insere
        (goto-char beg)
        (forward-line -1)
        (let ((new-beg (point)))
          (insert text)
          ;; reativa a região no novo lugar
          (set-mark new-beg)
          (goto-char (+ new-beg (length text)))
          (setq deactivate-mark nil)))
    (leo/move-line-up)))

(defun leo/move-text-down ()
  "Move region down, or current line down if no region is active."
  (interactive)
  (if (use-region-p)
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (delete-and-extract-region beg end)))
        (goto-char beg)
        (forward-line 1)
        (let ((new-beg (point)))
          (insert text)
          (set-mark new-beg)
          (goto-char (+ new-beg (length text)))
          (setq deactivate-mark nil)))
    (leo/move-line-down)))

(map! :nvi "M-j" #'leo/move-text-down
      :nvi "M-k" #'leo/move-text-up)
