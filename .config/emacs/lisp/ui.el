;;; ui.el --- Theme and visual polish -*- lexical-binding: t; -*-

(setq display-line-numbers-type t)
(setq-default display-line-numbers-width 3
              display-line-numbers-widen t)

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
(setq global-hl-line-sticky-flag 'window)
(global-hl-line-mode 1)

(when (display-graphic-p)
  (let* ((candidates (if (eq system-type 'windows-nt)
                         '("JetBrainsMono NF" "JetBrains Mono" "Cascadia Code" "Consolas")
                       '("CaskaydiaCove Nerd Font" "Cascadia Code" "Monospace")))
         (font-family (seq-find #'find-font
                                (mapcar (lambda (family) (font-spec :family family))
                                        candidates))))
    (when font-family
      (set-face-attribute 'default nil :font font-family :height 130)
      (set-face-attribute 'fixed-pitch nil :font font-family :height 130)
      (set-face-attribute 'variable-pitch nil :font font-family :height 130))))

(let ((vendor-dir (expand-file-name "vendor/" (file-name-directory (or load-file-name buffer-file-name)))))
  (when (file-directory-p vendor-dir)
    (add-to-list 'load-path vendor-dir)))

(use-package doom-themes
  :ensure nil
  :demand t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (leo/load-theme 'doom-one)
  (when (boundp 'enable-theme-functions)
    (add-hook 'enable-theme-functions #'doom-themes-org-config))
  (doom-themes-org-config))

(use-package solaire-mode
  :ensure nil
  :hook (after-init . solaire-global-mode))

(use-package doom-modeline
  :ensure nil
  :hook (after-init . doom-modeline-mode)
  :hook (doom-modeline-mode . size-indication-mode)
  :hook (doom-modeline-mode . column-number-mode)
  :init
  (setq doom-modeline-icon nil
        doom-modeline-height 30
        doom-modeline-bar-width 3
        doom-modeline-github nil
        doom-modeline-mu4e nil
        doom-modeline-persp-name nil
        doom-modeline-minor-modes nil
        doom-modeline-major-mode-icon nil
        doom-modeline-check 'simple
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-buffer-encoding 'nondefault
        doom-modeline-default-eol-type (if (eq system-type 'windows-nt) 1 0))
  :config
  (doom-modeline-refresh-bars))

(use-package emacs
  :ensure nil
  :hook ((prog-mode . display-line-numbers-mode)
         (text-mode . visual-line-mode)))

(provide 'ui)
;;; ui.el ends here
