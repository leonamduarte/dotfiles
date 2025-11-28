
;;; tools-project.el --- Gerenciamento de projetos ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; - project.el nativo
;; - integração com Consult
;; - Treemacs helpers
;; - Eshell no root
;; - Build inteligente
;; - Leader keys SPC p …

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; project.el — núcleo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package project
  :config
  ;; Deixa o project.el fazer o básico, sem remapear teclas globais
  (setq project-switch-commands
        '((project-find-file "Find file")
          (consult-ripgrep  "Search")
          (project-find-dir "Find dir")
          (project-switch-to-buffer "Buffers"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers seguros para root do projeto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-root ()
  "Retorna project root ou default-directory como fallback."
  (or (and (project-current)
           (project-root (project-current)))
      default-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treemacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-treemacs ()
  "Abre Treemacs focado no projeto."
  (interactive)
  (let ((default-directory (leo/project-root)))
    (treemacs)
    (treemacs-find-file)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eshell no projeto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-eshell ()
  "Abre um Eshell no root do projeto."
  (interactive)
  (let ((default-directory (leo/project-root)))
    (eshell t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Build inteligente
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-build ()
  "Executa build baseado nos arquivos do projeto."
  (interactive)
  (let* ((root (leo/project-root))
         (npm     (expand-file-name "package.json" root))
         (maven   (expand-file-name "pom.xml" root))
         (gradlew (expand-file-name "gradlew" root)))
    (cond
     ((file-exists-p npm)     (compile "npm install"))
     ((file-exists-p maven)   (compile "mvn clean install -DskipTests"))
     ((file-exists-p gradlew) (compile "./gradlew build"))
     (t (message "Nenhum sistema de build encontrado.")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Consult + project (apenas binds úteis)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package consult
  :commands consult-ripgrep)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom-style leader bindings (SPC p …)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  (define-key leo/leader-project-map (kbd "p") #'project-switch-project)
  (define-key leo/leader-project-map (kbd "f") #'project-find-file)
  (define-key leo/leader-project-map (kbd "d") #'project-find-dir)
  (define-key leo/leader-project-map (kbd "b") #'project-switch-to-buffer)
  (define-key leo/leader-project-map (kbd "s") #'consult-ripgrep)
  (define-key leo/leader-project-map (kbd "e") #'leo/project-eshell)
  (define-key leo/leader-project-map (kbd "t") #'leo/project-treemacs)
  (define-key leo/leader-project-map (kbd "c") #'leo/project-build))

(provide 'tools-project)
;;; tools-project.el ends here
