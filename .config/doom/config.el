;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; --- CORREÇÃO DO MAGIT/TRANSIENT ---
;; Força o carregamento da versão correta do transient antes que o Emacs carregue a versão builtin.
(let ((lfile (concat doom-local-dir "straight/repos/transient/lisp/transient.el")))
  (if (file-exists-p lfile)
      (load lfile)))

(setq default-directory "~/")

;; -------------------------------
;; 1. IDENTIDADE & SISTEMA
;; -------------------------------
(setq user-full-name "bashln"
      user-mail-address "lpdmonteiro+doom@gmail.com")

;; Configuração condicional de Fontes
(if (eq system-type 'windows-nt)
    (setq doom-font (font-spec :family "JetBrainsMono NF" :size 16)
          doom-variable-pitch-font (font-spec :family "JetBrainsMono NF" :size 1 ))
  ;; Linux (Arch/CachyOS)
  (setq doom-font (font-spec :family "CommitMono Nerd Font" :size 16)
        doom-variable-pitch-font (font-spec :family "CommitMono Nerd Font" :size 16)))

;; UI Básica
(setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-rose-pine-moon)
;; (setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'macchiato) ;; Opções: latte, frappe, macchiato, mocha
(setq display-line-numbers-type t)
(setq confirm-kill-emacs nil)
(setq-default tab-width 2)

;; -------------------------------
;; 2. ORG MODE
;; -------------------------------
(after! org
  (setq org-directory "~/org/"
        org-default-notes-file (expand-file-name "inbox.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAIT(w)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)"))))

;; Habilita módulos extras do Org
(add-to-list 'org-modules 'org-habit)

;; Org Agenda Otimizada
(after! org-agenda
  (setq org-agenda-files (list (expand-file-name "tasks.org" org-directory)
                               (expand-file-name "work.org"  org-directory)
                               (expand-file-name "study.org" org-directory))
        org-agenda-start-on-weekday nil
        org-agenda-span 1
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t))

;; Org Super Agenda (Agrupamento visual)
(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "🔥 Urgente"  :deadline today :priority "A")
          (:name "🗓 Hoje"      :scheduled today)
          (:name "📦 Projetos" :tag "project")
          (:name "✅ Concluídas" :todo "DONE" :order 99))))

;; Org Modern (Visual limpo - substitui org-superstar se ativado)
;; Nota: Como temos +pretty no init.el, o Doom carrega org-superstar.
;; O Org-Modern compete com ele. Abaixo forçamos o modern.
(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-table t
        org-modern-star '("◉" "●" "○" "◆" "●" "○" "◆")
        org-modern-hide-stars t))

;; Auto Tangle (para seus dotfiles/literate config)
(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default t))

;; Helper: Inserir tag de auto-tangle
(defun leonam/insert-auto-tangle-tag ()
  (interactive)
  (if (derived-mode-p 'org-mode)
      (progn (save-excursion (goto-char (point-min)) (insert "#+auto_tangle: t\n"))
             (message "Tag inserida."))
    (message "Não é um buffer Org!")))

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle
      :desc "Insert auto_tangle" "i a" #'leonam/insert-auto-tangle-tag)

;; -------------------------------
;; 3. DESENVOLVIMENTO (DevOps / FullStack)
;; -------------------------------

;; LSP & Go
(after! lsp-mode
  (setq lsp-go-use-gofumpt t)
  (setq lsp-go-analyses '((nilness . t) (unusedparams . t) (unusedwrite . t))))

;; JS / TS
(after! js2-mode
  (setq js2-basic-offset 2
        js2-bounce-indent-p nil
        js2-strict-missing-semi-warning nil))

(use-package! treesit-auto
  :config
  ;; (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

;; Copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t)
  (add-to-list 'copilot-indentation-alist '(prog-mode 2)))

(use-package! mason
  :config
  (mason-ensure))

;; -------------------------------
;; 4. COMPLETION & NAVEGAÇÃO
;; -------------------------------
;; Como Vertico e Corfu já estão no init.el, apenas ajustamos preferências.

(after! marginalia
  (marginalia-mode))

(after! corfu
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-cycle t
        corfu-popupinfo-delay 0.5
        corfu-popupinfo-max-height 6))
;; Ajuste no Orderless para busca
(after! orderless
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

;; Atalhos úteis para Consult e Embark
(map! :leader
      "b b" #'consult-buffer       ;; Buffer switcher melhorado
      "f r" #'consult-recent-file) ;; Arquivos recentes

(map! "C-." #'embark-act)          ;; Ações contextuais rápidas

(after! eldoc
  (setq eldoc-echo-area-use-multiline-p nil
        eldoc-display-functions '(eldoc-display-in-echo-area)))

(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))


;; -------------------------------
;; 5. Formatação de Texto
;; -------------------------------

(after! apheleia
  (setf (alist-get 'prettier apheleia-formatters)
        '("prettier" "--stdin-filepath" filepath))
  ;; usar prettier para css
  (setf (alist-get 'css-mode apheleia-mode-alist) 'prettier)
  (apheleia-global-mode +1))

;; Força a remoção de trailing whitespace em TODOS os arquivos ao salvar
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Opcional: Configura o stylua para usar indentação de 2 ou 4 espaços (ajuste conforme gosto)
(setq-hook! 'lua-mode-hook +format-with-lsp nil) ; Prefira o formatador externo ao LSP

;; -------------------------------
;; 6. CUSTOM FACES (Aparência Fina)
;; -------------------------------
(custom-set-faces!
  '(org-level-8 :inherit outline-3 :height 1.1)
  '(org-level-7 :inherit outline-3 :height 1.1)
  '(org-level-6 :inherit outline-3 :height 1.2)
  '(org-level-5 :inherit outline-3 :height 1.2)
  '(org-level-4 :inherit outline-3 :height 1.3)
  '(org-level-3 :inherit outline-3 :height 1.3)
  '(org-level-2 :inherit outline-2 :height 1.4)
  '(org-level-1 :inherit outline-1 :height 1.5)
  '(org-document-title  :height 1.5 :bold t :underline nil)
  '(org-checkbox :height 1.5))

;; -------------------------------
;; 7. Keymaps Personalizados
;; -------------------------------

;; Neotree Toggle
;; Usa o neotree como gerenciador de arquivos lateral
(map! :leader
      :desc "Toggle Neotree" "o n" #'neotree-toggle)

(map! :leader
      :desc "Neotree Directory" "o N" #'neotree-dir)

;; -------------------------------
;; 8. Greese.el (pacote local) (https://github.com/mwac-dev/grease.el)
;; -------------------------------

(use-package! grease
  ;; :commands (grease-open grease-toggle grease-here)
  :init
  (setq grease-sort-method 'type
        grease-show-hidden nil
        grease-preview-window-width 0.4)
  :config
  (map! :leader
        (:prefix ("o g" . "Grease")
         :desc "Toggle Grease"           "g" #'grease-toggle
         :desc "Open Grease (current)"   "o" #'grease-open
         :desc "Open at project root"    "h" #'grease-here)
        :desc "Toggle Grease like Oil.nvim" "-" #'grease-toggle))

;; ----------------------------------------------
;; 9. Mason (Gerenciador de LSP/DAP/Formatadores)
;; ----------------------------------------------

(use-package! mason
  :config
  (mason-setup))

;; ---------------------
;; 10. emacs-lsp-booster
;; ---------------------

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
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-booster--advice-tramp-remote-path
             lisp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;; Aumenta o limite de leitura de processos (crucial para LSP)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; Usa plists para deserialização (muito mais rápido que hash-tables)
(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

;; Ajuste de delay para parecer mais "snappy"
(setq lsp-idle-delay 0.500)
(setq lsp-log-io nil) ; Bloat de log mata performance

;; Fim do config.el
