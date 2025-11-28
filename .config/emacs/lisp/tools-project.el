;;; project.el --- Gerenciamento de projetos ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo fornece:
;; - project.el nativo (rápido e leve)
;; - integração com Consult
;; - atalhos úteis ao estilo Doom
;; - integração com Treemacs
;; - helpers de navegação entre arquivos, diretórios e roots

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; project.el nativo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package project
  :ensure nil ;; já vem com o Emacs
  :config
  ;; Comando principal ao estilo Doom: "SPC p p"
  (define-key project-prefix-map (kbd "p") #'project-switch-project)
  (define-key project-prefix-map (kbd "f") #'project-find-file)
  (define-key project-prefix-map (kbd "d") #'project-find-dir)
  (define-key project-prefix-map (kbd "b") #'project-switch-to-buffer)
  (define-key project-prefix-map (kbd "k") #'project-kill-buffers))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Consult + project.el (substitui projectile + helm/ivy)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package consult
  :ensure nil
  :bind (("C-c p p" . project-switch-project)
         ("C-c p f" . project-find-file)
         ("C-c p s" . consult-ripgrep)
         ("C-c p b" . project-switch-to-buffer)
         ("C-c p d" . project-find-dir)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper: abrir root do projeto no Treemacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-treemacs ()
  "Abre treemacs focado no projeto atual."
  (interactive)
  (let ((root (project-root (project-current))))
    (treemacs)
    (treemacs-find-file)
    (message "Treemacs → %s" root)))

(global-set-key (kbd "C-c p t") #'leo/project-treemacs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper: abrir terminal dentro do projeto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-eshell ()
  "Abre um eshell na raiz do projeto."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (eshell t)))

(global-set-key (kbd "C-c p e") #'leo/project-eshell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper: run build do projeto (detecção simples)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-build ()
  "Executa 'npm install', 'mvn install', 'gradle build' dependendo do projeto."
  (interactive)
  (let* ((root (project-root (project-current)))
         (npm (expand-file-name "package.json" root))
         (mvn (expand-file-name "pom.xml" root))
         (gradle (expand-file-name "build.gradle" root)))
    (cond
     ((file-exists-p npm)     (compile "npm install"))
     ((file-exists-p mvn)     (compile "mvn clean install -DskipTests"))
     ((file-exists-p gradle)  (compile "./gradlew build"))
     (t (message "Não encontrei build system no projeto.")))))

(global-set-key (kbd "C-c p C") #'leo/project-build)

(provide 'tools-project)
;;; tools-project.el ends here
