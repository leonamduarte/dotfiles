;;; editor-evil.el --- Vim everywhere, versão modular -*- lexical-binding: t; -*-

;;; Evil básico
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil ;; necessário para evil-collection
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-want-C-i-jump t
        evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)

  ;; linhas relativas apenas para arquivos de texto/código
  (setq display-line-numbers-type 'relative)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode))

;;; Evil Collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;;; Treemacs + Evil
(use-package treemacs-evil
  :after (treemacs evil))


;;; ESC fecha prompts (como no Doom)
(defun leo/escape-minibuffer ()
  (interactive)
  (if (minibufferp)
      (abort-recursive-edit)
    (keyboard-escape-quit)))

(global-set-key (kbd "<escape>") #'leo/escape-minibuffer)

;;; Abrir treemacs como no Doom
(global-set-key (kbd "C-c t") #'treemacs)

;; ;; "jk" como ESC opcional
;; (use-package evil-escape
;;   :config
;;   (evil-escape-mode)
;;   (setq evil-escape-key-sequence "jk"))

(provide 'editor-evil)
;;; editor-evil.el ends here
