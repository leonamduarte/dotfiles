;;; utils.el --- Shared custom helpers -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'seq)
(require 'subr-x)

(defun leo/project-root-dired ()
  "Open Dired in the current project root."
  (interactive)
  (if-let ((project (project-current nil)))
      (dired (project-root project))
    (call-interactively #'dired)))

(defun leo/config-candidates (root)
  "Return relative file and directory candidates under ROOT."
  (let ((entries (directory-files root t directory-files-no-dot-files-regexp))
        candidates)
    (dolist (entry entries candidates)
      (let ((name (file-relative-name entry root)))
        (if (file-directory-p entry)
            (progn
              (push (concat name "/") candidates)
              (dolist (child (leo/config-candidates entry))
                (push (concat name "/" child) candidates)))
          (push name candidates))))))

(defun leo/open-config-entry ()
  "Select a file or directory from the Emacs config tree."
  (interactive)
  (let* ((root (file-name-as-directory user-emacs-directory))
         (choice (completing-read "Config: " (sort (leo/config-candidates root) #'string<) nil t)))
    (when (and choice (not (string-empty-p choice)))
      (let ((path (expand-file-name choice root)))
        (if (file-directory-p path)
            (dired path)
          (find-file path))))))

(defvar leo/workspace-main-name "main"
  "Name of the default workspace.")

(defvar leo/workspace--last nil
  "Most recently selected workspace name.")

(defvar leo/workspace-show-tab-bar nil
  "Whether the native tab bar should be visible.")

(defface leo/workspace-tab-selected-face
  '((t (:inherit highlight)))
  "Face for the selected workspace in the echo area.")

(defface leo/workspace-tab-face
  '((t (:inherit default)))
  "Face for non-selected workspaces in the echo area.")

(defun leo/workspace-storage-directory ()
  "Return the directory used to store saved workspaces."
  (let ((dir (expand-file-name "workspaces/" user-emacs-directory)))
    (make-directory dir t)
    dir))

(defun leo/workspace-snapshot-directory ()
  "Return the directory used to store saved workspace snapshots."
  (let ((dir (expand-file-name "saved/" (leo/workspace-storage-directory))))
    (make-directory dir t)
    dir))

(defun leo/workspace-last-session-file ()
  "Return the autosave file used for the last workspace session."
  (expand-file-name "last-session.el" (leo/workspace-storage-directory)))

(defun leo/workspace-list-tabs ()
  "Return the current list of tab-bar tabs."
  (funcall tab-bar-tabs-function))

(defun leo/workspace-list-names ()
  "Return the names of open workspaces."
  (mapcar (lambda (tab) (alist-get 'name tab))
          (leo/workspace-list-tabs)))

(defun leo/workspace-current-name ()
  "Return the name of the current workspace."
  (alist-get 'name (tab-bar--current-tab-find)))

(defun leo/workspace-exists-p (name)
  "Return non-nil when a workspace named NAME exists."
  (member name (leo/workspace-list-names)))

(defun leo/workspace--current-index ()
  "Return the zero-based index of the current workspace."
  (or (tab-bar--current-tab-index (leo/workspace-list-tabs)) 0))

(defun leo/workspace--generate-id ()
  "Return the next numeric default workspace id."
  (1+ (seq-reduce
       (lambda (max-id name)
         (if (string-match "\\`#\\([0-9]+\\)\\'" name)
             (max max-id (string-to-number (match-string 1 name)))
           max-id))
       (leo/workspace-list-names)
       0)))

(defun leo/workspace--tabline (&optional names)
  "Return a Doom-like workspace tabline for NAMES."
  (let* ((names (or names (leo/workspace-list-names)))
         (current-name (leo/workspace-current-name)))
    (mapconcat
     #'identity
     (cl-loop for name in names
              for index from 1
              collect
              (propertize (format "[%d] %s" index name)
                          'face (if (equal current-name name)
                                    'leo/workspace-tab-selected-face
                                  'leo/workspace-tab-face)))
     " ")))

(defun leo/workspace--message-body (message &optional type)
  "Build a workspace echo area line for MESSAGE and TYPE."
  (if (or (null message) (string-empty-p message))
      (leo/workspace--tabline)
    (concat (leo/workspace--tabline)
            (propertize " | " 'face 'font-lock-comment-face)
            (propertize message
                        'face (pcase type
                                ('error 'error)
                                ('warn 'warning)
                                ('success 'success)
                                (_ 'font-lock-comment-face))))))

(defun leo/workspace-message (message &optional type)
  "Show MESSAGE next to the current workspace list."
  (let (message-log-max)
    (message "%s" (leo/workspace--message-body message type))))

(defun leo/workspace-error (message &optional noerror)
  "Show MESSAGE as a workspace error.
When NOERROR is non-nil, use `message' instead of signaling."
  (funcall (if noerror #'message #'error)
           "%s"
           (leo/workspace--message-body
            (if (stringp message) message (format "%s" message))
            'error)))

(defun leo/workspace-display ()
  "Display the current workspace list in the echo area."
  (interactive)
  (leo/workspace-message ""))

(defun leo/workspace--sanitize-file-fragment (name)
  "Return a filesystem-safe fragment for NAME."
  (let ((clean (replace-regexp-in-string "[<>:\"/\\\\|?*]+" "_" name)))
    (if (string-empty-p clean) "workspace" clean)))

(defun leo/workspace--snapshot-file (name)
  "Return the snapshot file path for NAME."
  (expand-file-name
   (format "%s-%s.el"
           (leo/workspace--sanitize-file-fragment name)
           (substring (md5 name) 0 8))
   (leo/workspace-snapshot-directory)))

(defun leo/workspace--write-data (file data)
  "Persist DATA to FILE as readable Lisp."
  (make-directory (file-name-directory file) t)
  (with-temp-file file
    (let ((print-length nil)
          (print-level nil)
          (print-circle t))
      (prin1 data (current-buffer))
      (insert "\n"))))

(defun leo/workspace--read-data (file)
  "Read Lisp data from FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (read (current-buffer))))

(defun leo/workspace--buffer-snapshot (state)
  "Return a buffer snapshot alist for STATE."
  (cl-loop with seen = nil
           for buffer-id in (window-state-buffers state)
           for buffer-name = (cond ((bufferp buffer-id) (buffer-name buffer-id))
                                   ((stringp buffer-id) buffer-id)
                                   (t nil))
           when (and buffer-name (not (member buffer-name seen)))
           do (push buffer-name seen)
           collect
           (let ((buffer (get-buffer buffer-name)))
             (cons buffer-name
                   (when (buffer-live-p buffer)
                     (buffer-local-value 'buffer-file-name buffer))))))

(defun leo/workspace--snapshot-tab (&optional tab name)
  "Return a serializable snapshot for TAB.
When NAME is non-nil, use it as the snapshot name."
  (let* ((tab (or tab (tab-bar--tab)))
         (name (or name (alist-get 'name tab)))
         (state (alist-get 'ws tab)))
    (list :version 1
          :name name
          :state state
          :buffers (leo/workspace--buffer-snapshot state))))

(defun leo/workspace--session-snapshot ()
  "Return a serializable snapshot of the current workspace session."
  (let* ((tabs (copy-sequence (leo/workspace-list-tabs)))
         (current-index (leo/workspace--current-index)))
    (setf (nth current-index tabs) (tab-bar--tab))
    (list :version 1
          :current (1+ current-index)
          :tabs (mapcar #'leo/workspace--snapshot-tab tabs))))

(defun leo/workspace--saved-snapshots ()
  "Return an alist of saved workspace names to files."
  (let ((dir (leo/workspace-snapshot-directory))
        snapshots)
    (dolist (file (directory-files dir t "\\.el\\'") (nreverse snapshots))
      (condition-case nil
          (let* ((data (leo/workspace--read-data file))
                 (name (plist-get data :name)))
            (when (stringp name)
              (push (cons name file) snapshots)))
        (error nil)))))

(defun leo/workspace--restore-buffers (buffers)
  "Prepare BUFFERS for a workspace restore."
  (dolist (entry buffers)
    (pcase-let ((`(,buffer-name . ,file-name) entry))
      (cond
       ((and file-name (file-readable-p file-name))
        (let ((buffer (find-file-noselect file-name)))
          (with-current-buffer buffer
            (when (and (stringp buffer-name)
                       (not (string= (buffer-name) buffer-name))
                       (not (get-buffer buffer-name)))
              (rename-buffer buffer-name)))))
       ((stringp buffer-name)
        (get-buffer-create buffer-name))))))

(defun leo/workspace--restore-snapshot (snapshot &optional reuse-current)
  "Restore SNAPSHOT into a workspace.
When REUSE-CURRENT is non-nil, restore into the current workspace."
  (let* ((name (plist-get snapshot :name))
         (state (plist-get snapshot :state))
         (buffers (plist-get snapshot :buffers)))
    (unless (and (stringp name) state)
      (user-error "Invalid workspace snapshot"))
    (leo/workspace--restore-buffers buffers)
    (unless reuse-current
      (let ((tab-bar-new-tab-choice "*scratch*"))
        (tab-bar-new-tab)))
    (unless (string= (leo/workspace-current-name) name)
      (tab-bar-rename-tab name))
    (delete-other-windows)
    (window-state-put state (frame-root-window) 'safe)
    name))

(defun leo/workspace-save-last-session ()
  "Persist the current workspace session for later restoration."
  (interactive)
  (condition-case nil
      (leo/workspace--write-data
       (leo/workspace-last-session-file)
       (leo/workspace--session-snapshot))
    (error nil)))

(defun leo/workspace-save (name)
  "Save the current workspace to a named snapshot file."
  (interactive (list (read-string "Save workspace as: " (leo/workspace-current-name))))
  (let ((file (leo/workspace--snapshot-file name)))
    (leo/workspace--write-data file (leo/workspace--snapshot-tab nil name))
    (leo/workspace-message (format "Saved '%s' workspace" name) 'success)))

(defun leo/workspace-load (name)
  "Load a saved workspace snapshot named NAME."
  (interactive
   (let ((snapshots (leo/workspace--saved-snapshots)))
     (unless snapshots
       (user-error "No saved workspaces"))
     (list (completing-read "Load workspace: " snapshots nil t))))
  (let* ((snapshots (leo/workspace--saved-snapshots))
         (file (cdr (assoc name snapshots))))
    (unless file
      (user-error "Unknown saved workspace: %s" name))
    (when (leo/workspace-exists-p name)
      (user-error "A workspace named '%s' is already open" name))
    (leo/workspace--restore-snapshot (leo/workspace--read-data file))
    (leo/workspace-message (format "Loaded '%s' workspace" name) 'success)))

(defun leo/workspace-delete-saved (name)
  "Delete the saved workspace snapshot named NAME."
  (interactive
   (let ((snapshots (leo/workspace--saved-snapshots)))
     (unless snapshots
       (user-error "No saved workspaces"))
     (list (completing-read "Delete saved workspace: " snapshots nil t))))
  (let* ((snapshots (leo/workspace--saved-snapshots))
         (file (cdr (assoc name snapshots))))
    (unless file
      (user-error "Unknown saved workspace: %s" name))
    (delete-file file)
    (leo/workspace-message (format "Deleted saved workspace '%s'" name) 'success)))

(defun leo/workspace--switch-to-index (index)
  "Switch to the workspace at one-based INDEX."
  (let ((tabs (leo/workspace-list-tabs)))
    (unless (and (integerp index)
                 (>= index 1)
                 (<= index (length tabs)))
      (user-error "No workspace at #%d" index))
    (tab-bar-select-tab index)
    (leo/workspace-display)))

(defun leo/workspace-switch-to (target)
  "Switch to TARGET, either by name or one-based index."
  (interactive
   (list (completing-read "Switch to workspace: "
                          (leo/workspace-list-names)
                          nil nil nil nil (leo/workspace-current-name))))
  (cond
   ((integerp target)
    (leo/workspace--switch-to-index target))
   ((and (stringp target)
         (string-match-p "\\`[0-9]+\\'" target))
    (leo/workspace--switch-to-index (string-to-number target)))
   ((stringp target)
    (if (leo/workspace-exists-p target)
        (progn
          (tab-bar-switch-to-tab target)
          (leo/workspace-display))
      (leo/workspace-new target)))
   (t
    (leo/workspace-error (format "No workspace called '%s'" target) t))))

(defun leo/workspace-switch-to-final ()
  "Switch to the final workspace."
  (interactive)
  (leo/workspace--switch-to-index (length (leo/workspace-list-tabs))))

(defun leo/workspace-other ()
  "Switch to the last selected workspace."
  (interactive)
  (if (and leo/workspace--last
           (leo/workspace-exists-p leo/workspace--last)
           (not (string= leo/workspace--last (leo/workspace-current-name))))
      (progn
        (tab-bar-switch-to-tab leo/workspace--last)
        (leo/workspace-display))
    (leo/workspace-message "No previous workspace" 'warn)))

(defun leo/workspace-cycle (step)
  "Cycle workspaces by STEP."
  (interactive "p")
  (let* ((tabs (leo/workspace-list-tabs))
         (count (length tabs)))
    (when (= count 1)
      (user-error "No other workspaces"))
    (leo/workspace--switch-to-index
     (1+ (mod (+ (leo/workspace--current-index) step) count)))))

(defun leo/workspace-switch-left (&optional count)
  "Switch to the workspace COUNT places to the left."
  (interactive "p")
  (leo/workspace-cycle (- (or count 1))))

(defun leo/workspace-switch-right (&optional count)
  "Switch to the workspace COUNT places to the right."
  (interactive "p")
  (leo/workspace-cycle (or count 1)))

(defun leo/workspace-new (&optional name)
  "Create a new workspace named NAME."
  (interactive)
  (let ((name (or name (format "#%d" (leo/workspace--generate-id)))))
    (when (leo/workspace-exists-p name)
      (user-error "A workspace named '%s' already exists" name))
    (let ((tab-bar-new-tab-choice "*scratch*"))
      (tab-bar-new-tab))
    (tab-bar-rename-tab name)
    (delete-other-windows)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (leo/workspace-message (format "Created '%s' workspace" name) 'success)))

(defun leo/workspace-new-named (name)
  "Create a new workspace with a given NAME."
  (interactive "sWorkspace name: ")
  (leo/workspace-new name))

(defun leo/workspace-rename (name)
  "Rename the current workspace to NAME."
  (interactive (list (read-string "Rename workspace to: " (leo/workspace-current-name))))
  (when (string-empty-p name)
    (user-error "Workspace name cannot be empty"))
  (when (and (not (string= name (leo/workspace-current-name)))
             (leo/workspace-exists-p name))
    (user-error "A workspace named '%s' already exists" name))
  (tab-bar-rename-tab name)
  (leo/workspace-message (format "Renamed workspace to '%s'" name) 'success))

(defun leo/workspace--killable-buffers ()
  "Return user buffers that can be safely killed for a workspace reset."
  (seq-filter
   (lambda (buffer)
     (let ((name (buffer-name buffer)))
       (and name
            (not (string-prefix-p " " name))
            (not (member name '("*Messages*" "*scratch*" "*dashboard*"))))))
   (buffer-list)))

(defun leo/workspace-reset-main ()
  "Reset the current workspace to a clean `main' state."
  (interactive)
  (dolist (buffer (leo/workspace--killable-buffers))
    (when (buffer-live-p buffer)
      (ignore-errors (kill-buffer buffer))))
  (delete-other-windows)
  (unless (string= (leo/workspace-current-name) leo/workspace-main-name)
    (tab-bar-rename-tab leo/workspace-main-name))
  (condition-case nil
      (if (fboundp 'leo/open-dashboard)
          (leo/open-dashboard)
        (switch-to-buffer (get-buffer-create "*scratch*")))
    (error (switch-to-buffer (get-buffer-create "*scratch*"))))
  (setq leo/workspace--last nil)
  (leo/workspace-message "Workspace reset to main" 'success))

(defun leo/workspace-kill ()
  "Kill the current workspace.
If it is the last workspace, reset it to `main' instead."
  (interactive)
  (let ((name (leo/workspace-current-name)))
    (if (> (length (leo/workspace-list-tabs)) 1)
        (progn
          (tab-bar-close-tab)
          (leo/workspace-message (format "Deleted '%s' workspace" name) 'success))
      (leo/workspace-reset-main))))

(defun leo/workspace-kill-session ()
  "Kill all workspaces and return to a clean `main' session."
  (interactive)
  (leo/workspace-save-last-session)
  (while (> (length (leo/workspace-list-tabs)) 1)
    (tab-bar-select-tab (length (leo/workspace-list-tabs)))
    (tab-bar-close-tab))
  (leo/workspace-reset-main)
  (leo/workspace-message "Killed workspace session" 'success))

(defun leo/workspace-restore-last-session ()
  "Restore the most recently autosaved workspace session."
  (interactive)
  (let ((file (leo/workspace-last-session-file)))
    (unless (file-exists-p file)
      (user-error "No saved workspace session"))
    (let* ((session (leo/workspace--read-data file))
           (tabs (plist-get session :tabs))
           (current (or (plist-get session :current) 1)))
      (unless tabs
        (user-error "Saved workspace session is empty"))
      (while (> (length (leo/workspace-list-tabs)) 1)
        (tab-bar-select-tab (length (leo/workspace-list-tabs)))
        (tab-bar-close-tab))
      (dolist (buffer (leo/workspace--killable-buffers))
        (when (buffer-live-p buffer)
          (ignore-errors (kill-buffer buffer))))
      (leo/workspace--restore-snapshot (car tabs) t)
      (dolist (snapshot (cdr tabs))
        (leo/workspace--restore-snapshot snapshot))
      (leo/workspace--switch-to-index current)
      (leo/workspace-message "Restored last workspace session" 'success))))

(defun leo/workspace-toggle-tab-bar ()
  "Toggle visibility of the native tab bar."
  (interactive)
  (setq leo/workspace-show-tab-bar (not leo/workspace-show-tab-bar)
        tab-bar-show (if leo/workspace-show-tab-bar 1 nil))
  (when (fboundp 'tab-bar--update-tab-bar-lines)
    (tab-bar--update-tab-bar-lines t))
  (force-mode-line-update t)
  (leo/workspace-message
   (if leo/workspace-show-tab-bar
       "Tab bar shown"
     "Tab bar hidden")
   'success))

(defun leo/workspace-ensure-main ()
  "Rename the initial workspace to `main' when appropriate."
  (interactive)
  (when (= (length (leo/workspace-list-tabs)) 1)
    (let ((current-tab (tab-bar--current-tab-find)))
      (unless (alist-get 'explicit-name current-tab)
        (tab-bar-rename-tab leo/workspace-main-name)))))

(defun leo/workspace--remember-last (from-tab to-tab)
  "Track the previously selected workspace from FROM-TAB to TO-TAB."
  (let ((from-name (alist-get 'name from-tab))
        (to-name (alist-get 'name to-tab)))
    (unless (equal from-name to-name)
      (setq leo/workspace--last from-name))))

(defun leo/toggle-vterm ()
  "Toggle a shared vterm buffer."
  (interactive)
  (let* ((buffer-name "*vterm*")
         (buffer (get-buffer buffer-name))
         (window (and buffer (get-buffer-window buffer t))))
    (cond
     ((and window (eq (selected-window) window))
      (delete-window window))
     (window
      (select-window window))
     (buffer
      (pop-to-buffer buffer))
     (t
      (vterm buffer-name)))))

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
