;;; utils.el --- Shared custom helpers -*- lexical-binding: t; -*-

(defun leo/project-root-dired ()
  "Open Dired in the current project root."
  (interactive)
  (if-let ((project (project-current nil)))
      (dired (project-root project))
    (call-interactively #'dired)))

(defun leo/open-scratch-buffer ()
  "Switch to the scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*")))

(defun leo/toggle-truncate-lines ()
  "Toggle line truncation in the current buffer."
  (interactive)
  (setq truncate-lines (not truncate-lines))
  (recenter))

(defun leo/reload-config ()
  "Reload the current Emacs configuration."
  (interactive)
  (dolist (feature '(ui startup navigation discoverability utils defaults))
    (when (featurep feature)
      (ignore-errors (unload-feature feature t))))
  (load-file user-init-file)
  (message "Configuration reloaded."))

(defun leo/restart-emacs ()
  "Restart Emacs by launching a fresh daemon and client."
  (interactive)
  (save-some-buffers t)
  (let* ((emacs-exe (expand-file-name invocation-name invocation-directory))
         (client-candidates
          (list (expand-file-name "emacsclientw.exe" invocation-directory)
                (expand-file-name "emacsclient.exe" invocation-directory)
                (executable-find "emacsclientw")
                (executable-find "emacsclient")))
         (client-exe (seq-find #'identity client-candidates))
         (shell-exe (or (executable-find "pwsh")
                        (executable-find "powershell"))))
    (unless (and (file-exists-p emacs-exe) client-exe shell-exe)
      (user-error "Could not resolve emacs/emacsclient executables for restart"))
    (start-process
     "leo-emacs-restart" nil shell-exe
     "-NoProfile" "-WindowStyle" "Hidden" "-Command"
     (format "Start-Sleep -Milliseconds 500; Start-Process -FilePath '%s' -ArgumentList '--daemon'; Start-Sleep -Seconds 1; Start-Process -FilePath '%s' -ArgumentList '-c'"
             emacs-exe client-exe))
    (save-buffers-kill-emacs)))

(defun leo/move-line (n)
  "Move the current line one line in the direction of N."
  (if (> n 0)
      (progn
        (forward-line 1)
        (transpose-lines 1)
        (forward-line -1))
    (progn
      (transpose-lines 1)
      (forward-line -2))))

(defun leo/move-text (n)
  "Move the region by N lines, or the current line by one step toward N."
  (interactive "p")
  (if (use-region-p)
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (delete-and-extract-region beg end)))
        (goto-char beg)
        (forward-line n)
        (let ((new-beg (point)))
          (insert text)
          (set-mark new-beg)
          (goto-char (+ new-beg (length text)))
          (setq deactivate-mark nil)))
    (leo/move-line n)))

(defun leo/move-text-up ()
  "Move the region up, or the current line up."
  (interactive)
  (leo/move-text -1))

(defun leo/move-text-down ()
  "Move the region down, or the current line down."
  (interactive)
  (leo/move-text 1))

(defun leo/evil-black-hole-delete-char ()
  "Delete forward without touching the default register."
  (interactive)
  (delete-char 1))

(defun leo/evil-visual-shift-left ()
  "Shift the active visual selection left and restore it."
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun leo/evil-visual-shift-right ()
  "Shift the active visual selection right and restore it."
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(provide 'utils)
;;; utils.el ends here
