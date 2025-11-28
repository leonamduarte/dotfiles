
;;; core.el --- Núcleo do Emacs modular -*- lexical-binding: t; -*-
;;; Commentary:
;; Ajustes essenciais inspirados no Doom:
;; - Performance sensata pós-startup
;; - Comportamento consistente
;; - UI básica limpa
;; - Encoding, scrolling, buffers e janelas estáveis

;;; Code:

;; ============================================================================
;; Desempenho
;; ============================================================================

;; GC moderado para uso normal (early-init cuida do startup)
(setq gc-cons-threshold (* 32 1024 1024)
      gc-cons-percentage 0.1)

;; I/O maior para linguagem server protocol e processos externos
(setq read-process-output-max (* 4 1024 1024)) ;; 4MB

;; Preferir arquivos mais novos (útil para byte-compile em config modular)
(setq load-prefer-newer t)

;; ============================================================================
;; Caminhos básicos
;; ============================================================================

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ============================================================================
;; Comportamento geral
;; ============================================================================

;; Confirmar ações com y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; Encoding padrão (estilo Doom)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; Históricos mais úteis
(savehist-mode 1)
(setq history-length 500)

;; Backups organizados
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 2
      version-control t)

;; Auto-save ligado
(setq auto-save-default t)

;; ============================================================================
;; UI básica (o resto fica no módulo ui.el)
;; ============================================================================

;; Evita telas de intro
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

;; Comportamento das janelas
(setq split-height-threshold nil
      split-width-threshold 80)

;; Scrolling suave (similar ao Doom)
(setq scroll-step 1
      scroll-margin 2
      scroll-conservatively 101)

;; ============================================================================
;; Indentação e whitespace
;; ============================================================================

(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 100)

;; Linha final garantida em arquivos
(setq require-final-newline t)

;; ============================================================================
;; Undo
;; ============================================================================

;; Se estiver usando undo-fu (como no seu Evil), isso é a base
(setq undo-limit (* 20 1024 1024)
      undo-strong-limit (* 30 1024 1024))

;; ============================================================================
;; Finalização
;; ============================================================================

(provide 'core)
;;; core.el ends here
