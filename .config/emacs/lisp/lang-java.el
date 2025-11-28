;;; lang-java.el --- Suporte moderno para Java -*- lexical-binding: t; -*-
;;; Commentary:
;; Suporte completo para Java com:
;; - java-ts-mode (treesitter)
;; - LSP via jdtls (Eglot)
;; - Helpers para Maven e Gradle
;; - Formatação com google-java-format
;; - Execução de arquivos .java
;;
;; Recria e expande o equivalente ao módulo Doom :lang java +lsp +tree-sitter

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Java com Treesitter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.java\\'" . java-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eglot + JDTLS (Language Server oficial do Java)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(java-ts-mode . ("jdtls"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers para Java puro (compilar e rodar)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/java-run ()
  "Compila e roda o arquivo Java atual."
  (interactive)
  (when buffer-file-name
    (let* ((file buffer-file-name)
           (dir (file-name-directory file))
           (base (file-name-sans-extension
                  (file-name-nondirectory file))))
      (compile (format "javac %s && java -cp %s %s"
                       file dir base)))))

(global-set-key (kbd "C-c j r") #'leo/java-run)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Maven helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/maven-clean-install ()
  "Roda mvn clean install."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (compile "mvn clean install -DskipTests")))

(defun leo/maven-run ()
  "Roda mvn spring-boot:run (frequente em APIs)."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (compile "mvn spring-boot:run")))

(global-set-key (kbd "C-c j m") #'leo/maven-clean-install)
(global-set-key (kbd "C-c j s") #'leo/maven-run)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gradle helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun leo/gradle-build ()
  "Roda gradle build."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (compile "./gradlew build")))

(defun leo/gradle-run ()
  "Roda gradle bootRun (APIs em Spring + Kotlin)."
  (interactive)
  (let ((default-directory (project-root (project-current))))
    (compile "./gradlew bootRun")))

(global-set-key (kbd "C-c j g") #'leo/gradle-build)
(global-set-key (kbd "C-c j b") #'leo/gradle-run)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indentação e estilo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq java-ts-mode-indent-offset 4)

(provide 'lang-java)
;;; lang-java.el ends here
