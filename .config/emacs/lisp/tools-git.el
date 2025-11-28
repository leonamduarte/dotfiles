;;; tools-git.el --- Integração com Git, Magit e Forge -*- lexical-binding: t; -*-
;;; Commentary:
;; Este módulo recria o equivalente ao módulo Doom:
;;   :tools (magit +forge)
;;   :ui (vc-gutter +pretty)
;;
;; Inclui:
;; - Magit completo com integrações
;; - Forge para GitHub/GitLab/etc
;; - Diffs na fringe (gutter bonito)
;; - Evil-Collection para tornar tudo mais natural

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit: o melhor cliente Git da galáxia
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Forge: issues e pull requests direto no Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package forge
  :after magit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VC Gutter: diffs na fringe (equivalente ao módulo vc-gutter +pretty)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; Atualiza gutter em tempo real
  (diff-hl-flydiff-mode 1)
  (diff-hl-margin-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil integration (como no Doom)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil-collection-magit
  :ensure nil
  :after (evil magit)
  :config
  (evil-collection-magit-setup))

(provide 'tools-git)
;;; tools-git.el ends here
