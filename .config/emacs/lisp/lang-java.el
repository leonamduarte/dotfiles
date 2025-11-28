
;;; lang-java.el --- Suporte moderno para Java ao estilo Doom -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte completo para Java:
;; - java-ts-mode (tree-sitter)
;; - LSP com jdtls + workspace por projeto
;; - Maven/Gradle helpers
;; - Runner de arquivos
;; - Integração com Apheleia
;; - Atalhos integrados ao leader SPC

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.java\\'" . java-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot + JDTLS com workspace por projeto (como Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (defun leo/jdtls-start ()
    "Inicia jdtls com workspace por projeto."
    (let* ((project (project-current))
           (root (or (and project (project-root project))
                     (file-name-directory buffer-file-name)))
           (workspace (expand-file-name ".jdtls-workspace" root)))
      (list "jdtls" "-data" workspace)))

  (add-to-list 'eglot-server-programs
               `(java-ts-mode . leo/jdtls-start)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Runner Java (arquivo simples)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/java-run ()
  "Compila e executa o arquivo Java atual. Para projetos Maven/Gradle, use os comandos dedicados."
  (interactive)
  (unless buffer-file-name
    (user-error "Este buffer não possui arquivo associado."))

  (let* ((file buffer-file-name)
         (dir (file-name-directory file))
         (base (file-name-sans-extension
                (file-name-nondirectory file))))
    (compile (format "javac %s && java -cp %s %s" file dir base))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Maven
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/project-root-or-error ()
  "Retorna project-root ou lança erro amigável."
  (or (and (project-current) (project-root (project-current)))
      (user-error "Não foi possível detectar um projeto (Maven/Gradle).")))

(defun leo/maven-clean-install ()
  (interactive)
  (let ((default-directory (leo/project-root-or-error)))
    (compile "mvn clean install -DskipTests")))

(defun leo/maven-run ()
  (interactive)
  (let ((default-directory (leo/project-root-or-error)))
    (compile "mvn spring-boot:run")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gradle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/gradle-build ()
  (interactive)
  (let ((default-directory (leo/project-root-or-error)))
    (compile "./gradlew build")))

(defun leo/gradle-run ()
  (interactive)
  (let ((default-directory (leo/project-root-or-error)))
    (compile "./gradlew bootRun")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Atalhos Doom-like (SPC m j …)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'bindings
  ;; Prefixo: SPC m j
  (define-prefix-command 'leo/leader-java-map)
  (define-key leo/leader-map (kbd "m j") 'leo/leader-java-map)

  (define-key leo/leader-java-map (kbd "r") #'leo/java-run)
  (define-key leo/leader-java-map (kbd "m") #'leo/maven-clean-install)
  (define-key leo/leader-java-map (kbd "s") #'leo/maven-run)
  (define-key leo/leader-java-map (kbd "g") #'leo/gradle-build)
  (define-key leo/leader-java-map (kbd "b") #'leo/gradle-run))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq java-ts-mode-indent-offset 4)

(provide 'lang-java)
;;; lang-java.el ends here
