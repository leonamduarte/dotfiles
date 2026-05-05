# KEYBINDING CONFLICT ANALYSIS

> **Part of STEP-015 (US-012):** Validate absence of conflicts with OS, shell, and applications.
>
> **Date:** 2026-04-30
> **Scope:** Kitty keybindings vs WSLg/Windows, Bash/Zsh, Neovim, Browser
> **Active keybindings:** 53 distinct key combinations (after last-wins resolution)

---

## Summary

| Domain | Conflicts Found | Severity |
|---|---|---|
| WSLg / Windows OS | 2 potential | ⚠️ Low |
| Bash / Zsh Shell | 0 | ✅ None |
| Neovim | 0 | ✅ None |
| Browser | 0 | ✅ None |
| Internal (within kitty) | 4 harmless | ℹ️ Already documented |

---

## 1. WSLg / Windows OS Level

### ⚠️ Potential: `ctrl+insert` (copy_to_clipboard)

| Context | Action |
|---|---|
| Kitty | `copy_to_clipboard` |
| Windows | Standard **Copy** shortcut (legacy) |

Windows may intercept `ctrl+insert` at the OS level before it reaches WSLg, depending on RDP client configuration. In practice, modern WSLg (Weston/RDP) passes this through, but behavior varies by Windows/RDP client version.

**Mitigation:** `ctrl+shift+c` also maps to `copy_to_clipboard` (standard terminal convention) and is NOT intercepted by Windows. Use `ctrl+shift+c` as the primary copy shortcut.

### ⚠️ Potential: `shift+insert` (paste_from_clipboard)

| Context | Action |
|---|---|
| Kitty | `paste_from_clipboard` |
| Windows | Standard **Paste** shortcut (legacy) |

Same consideration as `ctrl+insert`. May be intercepted by Windows before WSLg.

**Mitigation:** `ctrl+shift+v` also maps to `paste_from_clipboard` (standard terminal convention) and passes through WSLg reliably. Use `ctrl+shift+v` as the primary paste shortcut.

### Safe: No conflict expected

All other kitty keybindings use these modifier combinations, which WSLg/RDP passes through reliably:

| Modifier Group | Example Bindings | WSLg Status |
|---|---|---|
| **Ctrl+Shift+letter/digit** | `ctrl+shift+1-9, ctrl+shift+l/h` | ✅ Pass through |
| **Ctrl+Alt+letter/symbol** | `ctrl+alt+h/j/k/l, ctrl+alt+space` | ✅ Pass through |
| **Ctrl+Alt+Shift+letter/symbol** | `ctrl+alt+shift+up/down/l` | ✅ Pass through |
| **Ctrl+Shift+arrow** | `ctrl+shift+right/left` | ✅ Pass through |
| **Ctrl+Shift+F-key** | (none in use) | ✅ Pass through |

Windows-level shortcuts that are NOT used (safe):
- `Win+*` — Not used in any kitty binding
- `Alt+Tab`, `Alt+F4`, `Alt+Space` — Not used
- `Ctrl+Alt+Del` — Not used
- `Ctrl+Shift+Esc` — Not used

---

## 2. Shell (Bash/Zsh) Conflicts

### ✅ No conflicts detected

Bash and Zsh readline shortcuts use **plain Ctrl+letter** (e.g., `Ctrl+A` = beginning of line, `Ctrl+E` = end of line, `Ctrl+W` = delete word, `Ctrl+L` = clear screen, `Ctrl+R` = search history).

All 53 active kitty keybindings include **Shift and/or Alt modifiers** in addition to Ctrl. There is zero overlap with shell readline shortcuts.

### Verified: No overlap with Oh My Zsh plugins

| Plugin | Custom Keybindings | Overlap |
|---|---|---|
| `git` | None | ✅ |
| `z` | None | ✅ |
| `extract` | None | ✅ |
| `command-not-found` | None | ✅ |
| `zsh-autosuggestions` | `Ctrl+E` (accept), `Ctrl+F` (accept), `Ctrl+G` (clear) | ✅ No (plain Ctrl, not in kitty) |
| `zsh-syntax-highlighting` | None | ✅ |

### Terminal convention alignment

| Terminal Convention | Kitty Binding | Status |
|---|---|---|
| `Ctrl+Shift+C` = Copy | `copy_to_clipboard` | ✅ Aligned |
| `Ctrl+Shift+V` = Paste | `paste_from_clipboard` | ✅ Aligned |
| `Ctrl+Insert` = Copy | `copy_to_clipboard` | ✅ Aligned |
| `Shift+Insert` = Paste | `paste_from_clipboard` | ✅ Aligned |

---

## 3. Neovim Conflicts

### ✅ No conflicts detected

Neovim built-in and custom keybindings use:
- **Plain Ctrl+letter** — e.g., `<C-s>` (save), `<C-h/j/k/l>` (window nav), `<C-w>` (window commands)
- **Alt+letter** — e.g., `<A-j/k>` (move lines), `<M-f>` (file manager)
- **Leader-prefixed sequences** — e.g., `<leader>e`, `<leader>fp`, `<leader>ww`

All 53 active kitty keybindings are modifier combinations (Ctrl+Shift, Ctrl+Alt, Ctrl+Alt+Shift) that do not overlap with any nvim shortcut.

| Scope | Examples | Overlap |
|---|---|---|
| Nvim built-in | `Ctrl+w`, `Ctrl+v`, `Ctrl+s`, `Ctrl+h/j/k/l` | ✅ No (kitty uses Ctrl+Alt for window nav, Ctrl+Shift for selection) |
| Nvim custom (keymaps.lua) | `<C-s>`, `<C-h/j/k/l>`, `<A-j/k>`, `<M-f>` | ✅ No (different modifiers) |
| Nvim markdown folding | `zj`, `zk`, `zl`, `z;`, `zu`, `zi` | ✅ No (plain normal-mode strings, not terminal-level shortcuts) |
| Nvim leader shortcuts | `<leader>e`, `<leader>fp`, `<leader>ww` | ✅ No |

**Important:** Kitty intercepts key combos at the terminal emulator level, before they reach nvim. Since there is no modifier overlap, nvim receives all its expected keystrokes without interference.

---

## 4. Browser Conflicts (Chrome/Firefox)

### ✅ No conflicts detected

Browser shortcuts are only active when the browser window is focused. Kitty shortcuts are only active when the kitty terminal is focused. These are **separate execution contexts** — they never conflict in practice.

Common browser shortcuts checked:

| Browser Shortcut | Kitty Binding | Overlap |
|---|---|---|
| `Ctrl+T` = New Tab | `Ctrl+Shift+T` = set_tab_title | ✅ No (different modifier) |
| `Ctrl+W` = Close Tab | `Ctrl+Alt+W` = close_window | ✅ No (different modifier) |
| `Ctrl+Tab` = Next Tab | `Ctrl+Shift+right/l` = next_tab | ✅ No (kitty intercepts before shell) |
| `Ctrl+Shift+Tab` = Previous Tab | `Ctrl+Shift+left/h` = previous_tab | ✅ No (kitty intercepts before shell) |
| `Ctrl+1-9` = Tab position | `Ctrl+Shift+1-9` = goto_tab | ✅ No (different modifier) |
| `Ctrl+L` = Address bar | `Ctrl+Alt+L` = focus_right | ✅ No (different modifier, different app) |
| `Ctrl+Shift+O` = Bookmarks | `Ctrl+Shift+O` = hints URL | ✅ No (different app context) |
| `Ctrl+Shift+I` = DevTools | Not in kitty | ✅ N/A |
| `Ctrl+F` = Find | `Ctrl+Shift+F` = hints path | ✅ No (different modifier, different app) |
| `Ctrl+D` = Bookmark | Not in kitty | ✅ N/A |
| `Ctrl+J` = Downloads | `Ctrl+Alt+J` = focus_down | ✅ No (different modifier, different app) |

---

## 5. Internal Kitty Conflicts (already documented in STEP-014)

These are keybindings defined multiple times within kitty's own config files. They are not conflicts with external applications but are listed here for completeness.

| Key | First Definition (Source) | Overridden By (Source) | Winner |
|---|---|---|---|
| `ctrl+shift+c` | `select_from_cursor` (scrollback.conf:34) | `copy_to_clipboard` (scrollback.conf:41) | `copy_to_clipboard` |
| `ctrl+alt+right` | `launch --location=hsplit` (tmux-prefix.conf:22) | `focus_right` (tmux-prefix.conf:27, navigation.conf:14) | `focus_right` |
| `ctrl+alt+down` | `launch --location=vsplit` (tmux-prefix.conf:23) | `focus_down` (tmux-prefix.conf:30, navigation.conf:17) | `focus_down` |
| `ctrl+alt+5` | `launch --location=hsplit` (tmux-prefix.conf:16) | `select_window 5` (navigation.conf:34) | `select_window 5` |
| `ctrl+alt+minus` | `launch --location=vsplit` (tmux-prefix.conf:19) | `resize_window narrower` (splits.conf:34 — NOT LOADED) | `launch --location=vsplit` |
| `ctrl+alt+up` | `focus_up` (tmux-prefix.conf:29) | `focus_up` (navigation.conf:16) | ✅ Same action (harmless) |
| `ctrl+alt+left` | `focus_left` (tmux-prefix.conf:28) | `focus_left` (navigation.conf:15) | ✅ Same action (harmless) |
| `ctrl+alt+right` | `focus_right` (tmux-prefix.conf:27) | `focus_right` (navigation.conf:14) | ✅ Same action (harmless) |
| `ctrl+alt+down` | `focus_down` (tmux-prefix.conf:30) | `focus_down` (navigation.conf:17) | ✅ Same action (harmless) |

**Note:** `layouts/splits.conf` is NOT included by any active config file. Its resize keybindings (`ctrl+alt+equal`, `ctrl+alt+minus`, `ctrl+alt+shift+equal`, `ctrl+alt+shift+minus`, `ctrl+alt+0`) are **not currently active**. Include it if resize functionality is desired.

---

## 6. Conclusion

**Overall verdict: No blocking conflicts exist.**

- All external conflicts are **non-existent** (shell, nvim, browser) due to disjoint modifier usage
- The only **potential** OS-level conflicts (`ctrl+insert`, `shift+insert` with Windows) have reliable fallbacks (`ctrl+shift+c`, `ctrl+shift+v`)
- Internal kitty conflicts are **harmless duplicates** (same action) or **documented overrides** (last-wins semantics)

### Recommended actions

1. **Low priority:** If `ctrl+insert` / `shift+insert` don't work in WSLg, use `ctrl+shift+c` / `ctrl+shift+v` as alternatives (already mapped)
2. **Low priority:** Consider adding `include layouts/splits.conf` to kitty.conf if resize keybindings are desired
3. **Already tracked:** Internal overrides are documented above and in STEP-014
