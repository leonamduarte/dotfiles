;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).


;;; init.el --- Doom modules

(doom!
 :input

 :completion
 (vertico +icons)
 (corfu +icons)
 ;; (company +childframe)   ; use isto se preferir company em vez de corfu

 :ui
 doom
 doom-dashboard
 modeline
 (treemacs +lsp)
 (vc-gutter +pretty)
 workspaces
 ophints
 ;;(ligatures +extra)
 (popup +defaults)
 (tabs +workspace)
 (window-select +numbers)
 (unicode +iris)
 indent-guides
 (emoji +github)

 :editor
 (evil +everywhere)
 file-templates
 (format +onsave)
 fold
 snippets
 word-wrap

 :emacs
 (dired +icons)
 electric
 (ibuffer +icons)
 undo

 :term
 vterm

 :checkers
 (syntax +flymake)   ; use sem +flymake se preferir flycheck
 spell
 grammar

 :tools
 (lsp +peek)
 (tree-sitter +lsp)
 magit
 editorconfig
 (eval +overlay)
 lookup
 direnv
 (debugger +lsp)

 :os
 (:if IS-LINUX tty)

 :lang
 (javascript +lsp +tree-sitter)
 (org +pretty +roam2)
 (web +lsp)
 (json +lsp)
 (yaml +lsp)
 (docker +lsp)
 (python +lsp)
 (go +lsp)
 (lua +lsp)
 (sh +lsp)

 :config
 (default +bindings +smartparens))
