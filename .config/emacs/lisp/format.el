
;;; format.el --- Global formatting configuration (Doom-like) -*- lexical-binding: t; -*-

;;; Commentary:
;; Integração completa com Apheleia:
;; - Format-on-save universal
;; - Pipelines (isort → black)
;; - Formatters seguros
;; - Associação por major mode
;; - Fallbacks inteligentes (buffers sem arquivo)

;;; Code:

;; ----------------------------------------------------------------------------
;; Apheleia
;; ----------------------------------------------------------------------------

(use-package apheleia
  :init
  ;; Ativa globalmente (como Doom)
  (apheleia-global-mode +1)

  :config
  ;; Remove loggers do Apheleia (ruído)
  (setq apheleia-loggers nil)

  ;; --------------------------------------------------------------------------
  ;; Formatters (redefinição completa, mais estável que setf)
  ;; --------------------------------------------------------------------------

  (setq apheleia-formatters
        '((prettier
           . ("prettier" "--stdin-filepath" filepath))
          (black
           . ("black" "-"))
          (isort
           . ("isort" "--stdout" "-"))
          (python-format
           . (("isort" "--stdout" filepath)
              ("black" "-")))
          (google-java
           . ("google-java-format" "-"))
          (shfmt
           . ("shfmt" "-i" "4" "-"))))

  ;; --------------------------------------------------------------------------
  ;; Associação de modo → formatter
  ;; --------------------------------------------------------------------------

  (setq apheleia-mode-alist
        '((html-ts-mode       . prettier)
          (css-ts-mode        . prettier)
          (web-mode           . prettier)
          (js-mode            . prettier)
          (js-ts-mode         . prettier)
          (json-mode          . prettier)
          (json-ts-mode       . prettier)
          (typescript-ts-mode . prettier)
          (tsx-ts-mode        . prettier)
          (yaml-ts-mode       . prettier)

          (python-mode        . python-format)
          (python-ts-mode     . python-format)

          (java-ts-mode       . google-java)

          (sh-mode            . shfmt)
          (bash-ts-mode       . shfmt)))

  ;; --------------------------------------------------------------------------
  ;; Fallback para buffers sem arquivo (prettier falha se não tiver filepath)
  ;; --------------------------------------------------------------------------

  (defun leo/apheleia-maybe-fix-filepath (orig-fn &rest args)
    "Se não houver arquivo associado, remova --stdin-filepath do prettier."
    (if (and (eq (apheleia--get-formatter) 'prettier)
             (not buffer-file-name))
        ;; formato mínimo
        (let ((apheleia-formatters
               (cons '(prettier . ("prettier"))
                     (assq-delete-all 'prettier apheleia-formatters))))
          (apply orig-fn args))
      (apply orig-fn args)))

  (advice-add 'apheleia--run-formatter :around #'leo/apheleia-maybe-fix-filepath))

;; ----------------------------------------------------------------------------
;; Comando manual Doom-like
;; ----------------------------------------------------------------------------

(defun leo/format-buffer ()
  "Format buffer usando Apheleia."
  (interactive)
  (apheleia-format-buffer))

;; Opcional: adiciona SPC c f (igual Doom)
(with-eval-after-load 'bindings
  (define-key leo/leader-map (kbd "c f") #'leo/format-buffer))

(provide 'format)
;;; format.el ends here
