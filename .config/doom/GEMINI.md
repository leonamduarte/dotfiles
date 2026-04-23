# Gemini Context: Doom Emacs Configuration

This directory contains the user's personal **Doom Emacs** configuration. It heavily customizes the standard Doom experience with specific workflows for development, organization, and file management.

## Project Structure

*   **`init.el`**: Controls which Doom modules are enabled (languages, tools, UI components).
*   **`config.el`**: The core of the user configuration. Contains keybindings, package settings, UI tweaks, and custom functions.
*   **`packages.el`**: Declares additional packages to install (via `package!`) or pins specific versions.
*   **`lisp/`**: Local custom Emacs Lisp libraries.
    *   **`lisp/grease/grease.el`**: A custom file manager implementation inspired by `oil.nvim` (allows editing the filesystem as a text buffer).
*   **`themes/`**: Custom theme definitions (e.g., `doom-rose-pine-*`).

## Key Features & Customizations

### 1. **Grease File Manager** (`lisp/grease/grease.el`)
A custom tool that enables file management by editing a buffer directly.
*   **Usage:**
    *   `SPC o g` / `SPC o g o`: Open Grease in current directory.
    *   `SPC o g h`: Open Grease at project root.
    *   `SPC o g g`: Toggle Grease.
*   **Functionality:** Edit filenames to rename, delete lines to remove files, copy/paste lines to duplicate/move. Changes are applied on save (`C-x C-s` or `SPC f s`).

### 2. **Development Workflow**
*   **LSP & Performance:**
    *   Uses `emacs-lsp-booster` for improved LSP performance.
    *   **Tuning:** `lsp-use-plists` enabled, formatting disabled in LSP (delegated to `apheleia`).
*   **Formatting:**
    *   **Apheleia:** Async formatting enabled globally.
    *   **Prettier:** Configured as the default formatter for JS, TS, CSS, JSON, YAML.
    *   **Style:** Strict cleanup (trailing whitespace deleted, final newline enforced).
*   **Completion:**
    *   **Corfu:** Main completion frontend (replacing Company). Tuned for speed (`0.1s` delay).
    *   **Copilot:** Integrated and bound to `C-j` (accept) / `C-S-j` (accept word) to avoid conflicts with Corfu's `TAB`.

### 3. **UI & Aesthetics**
*   **Font:** "JetBrainsMono Nerd Font" (Size 16, Semi-Light).
*   **Theme:** `doom-one` (Default). `catppuccin` is available but commented out.
*   **Org Mode:**
    *   Modern styling with `org-modern`.
    *   `org-auto-tangle` enabled for literate configs.
    *   `inbox.org` as the default capture target.

## Maintenance Commands

Run these commands in the terminal (outside Emacs) to maintain the configuration:

| Command | Description |
| :--- | :--- |
| `doom sync` | Synchronize config (run after editing `init.el` or `packages.el`). |
| `doom upgrade` | Upgrade Doom Emacs and all packages. |
| `doom doctor` | Diagnose common issues with the setup. |
| `doom env` | Regenerate the environment file (useful if shell `PATH` changes). |

## User Identity
*   **Name:** bashln
*   **Email:** `lpdmonteiro+doom@gmail.com`
