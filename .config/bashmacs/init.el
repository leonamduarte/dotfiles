;;; init.el --- Inicialização do Elpaca e Carregamento de Configurações -*- lexical-binding: t -*-
;;; Code:

;; O Elpaca precisa garantir que ele mesmo esteja instalado e carregado antes de qualquer use-package.

(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-language-environment "UTF-8")

(when (eq system-type 'windows-nt)
  ;; Windows tem limite baixo de handles/pipes
  (setq elpaca-queue-limit 3)
  (setq elpaca-process-limit 2))

;; ---------------------------------------------------------
;; A. BOOTSTRAP OFICIAL DO ELPACA (Seu Código)
;; ---------------------------------------------------------
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                       :ref nil :depth 1 :inherit ignore
                       :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                       :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))
;; ---------------------------------------------------------
;; B. PREPARAÇÃO PARA CARREGAMENTO DE PACOTES
;; ---------------------------------------------------------

;; 1. Habilita o modo de integração use-package do Elpaca
;; (elpaca-use-package-mode)

;; Install a package via the elpaca macro
;; See the "recipes" section of the manual for more details.

;; (elpaca example-package)

;; Install use-package support
(elpaca elpaca-use-package
        ;; Enable use-package :ensure support for Elpaca.
        (elpaca-use-package-mode))

;;When installing a package used in the init file itself,
;;e.g. a package which adds a use-package key word,
;;use the :wait recipe keyword to block until that package is installed/configured.
;;For example:
;;(use-package general :ensure (:wait t) :demand t)

;;Turns off elpaca-use-package-mode current declaration
;;Note this will cause evaluate the declaration immediately. It is not deferred.
;;Useful for configuring built-in emacs features.
(use-package emacs :ensure nil :config (setq ring-bell-function #'ignore))

;; 2. Restaura o GC para um valor razoável (10MB)
(setq gc-cons-threshold (* 10 1024 1024)) 

;; ---------------------------------------------------------
;; C. CARREGAMENTO DOS MÓDULOS (Onde estão seus use-packages)
;; ---------------------------------------------------------

(setq elpaca-use-package-by-default t)

(load (expand-file-name "config.el" user-emacs-directory))

;; (elpaca-wait)

(setq byte-compile-warnings '(not obsolete))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(copilot transient-cycles))
 '(package-vc-selected-packages
   '((copilot :url "https://github.com/copilot-emacs/copilot.el" :branch
	      "main"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-checkbox ((t (:height 1.2))))
 '(org-document-title ((t (:height 1.5 :weight bold))))
 '(outline-1 ((t (:foreground "#51afef" :weight bold :height 1.3))))
 '(outline-2 ((t (:foreground "#c678dd" :weight bold :height 1.2))))
 '(outline-3 ((t (:foreground "#98be65" :weight bold :height 1.15))))
 '(outline-4 ((t (:foreground "#da8548" :weight bold :height 1.1))))
 '(outline-5 ((t (:foreground "#5699af"))))
 '(outline-6 ((t (:foreground "#46d9ff"))))
 '(outline-7 ((t (:foreground "#a9a1e1"))))
 '(outline-8 ((t (:foreground "#ecbe7b")))))

;; ---------------------------------------------------------
;; FIM
;; ---------------------------------------------------------
(provide 'init)
;;; init.el ends here
