;;; ui.el --- Theme and visual polish -*- lexical-binding: t; -*-

(setq display-line-numbers-type 'relative)

(defun leo/load-theme (theme)
  "Disable current themes and load THEME."
  (interactive
   (list
    (intern
     (completing-read "Load theme: "
                      (mapcar #'symbol-name (custom-available-themes))
                      nil t))))
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme theme t))

(column-number-mode 1)
(global-hl-line-mode 1)

(when (display-graphic-p)
  (let* ((candidates (if (eq system-type 'windows-nt)
                         '("FantasqueSansM Nerd Font" "Cascadia Code" "Consolas")
                       '("CaskaydiaCove Nerd Font" "Cascadia Code" "Monospace")))
         (font-family (seq-find #'find-font
                                (mapcar (lambda (family) (font-spec :family family))
                                        candidates))))
    (when font-family
      (set-face-attribute 'default nil :font font-family :height 130)
      (set-face-attribute 'fixed-pitch nil :font font-family :height 130)
      (set-face-attribute 'variable-pitch nil :font font-family :height 130))))

(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (leo/load-theme 'doom-one))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-icon nil
        doom-modeline-height 24
        doom-modeline-bar-width 3))

(use-package emacs
  :ensure nil
  :hook ((prog-mode . display-line-numbers-mode)
         (text-mode . visual-line-mode)))

(provide 'ui)
;;; ui.el ends here
