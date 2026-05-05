# Test Checklist: Keyboard Navigation in All 7 Kitty Layouts

## Setup

1. Ensure kitty.conf includes all keybinding files:
   - `include keybindings/tmux-prefix.conf`
   - `include keybindings/navigation.conf`
   - `include keybindings/scrollback.conf`

2. Start kitty and create multiple windows in a single tab:
   - `Ctrl+Shift+Enter` — new window with CWD
   - `Ctrl+Alt+5` — horizontal split
   - `Ctrl+Alt+-` — vertical split
   - Create at least 3-4 windows for meaningful testing

3. Create multiple tabs:
   - `Ctrl+Alt+Enter` — new tab with CWD
   - Create at least 3 tabs for tab navigation testing

4. Switch between layouts using `Ctrl+Alt+Space`

---

## Navigation Keybindings to Test

| # | Shortcut | Action | Category |
|---|----------|--------|----------|
| 1 | `Ctrl+Alt+→` | focus_right | Pane |
| 2 | `Ctrl+Alt+←` | focus_left | Pane |
| 3 | `Ctrl+Alt+↑` | focus_up | Pane |
| 4 | `Ctrl+Alt+↓` | focus_down | Pane |
| 5 | `Ctrl+Alt+h` | focus_left (Vim style) | Pane |
| 6 | `Ctrl+Alt+j` | focus_down (Vim style) | Pane |
| 7 | `Ctrl+Alt+k` | focus_up (Vim style) | Pane |
| 8 | `Ctrl+Alt+l` | focus_right (Vim style) | Pane |
| 9 | `Ctrl+Alt+.` | next_window | Pane |
| 10 | `Ctrl+Alt+,` | previous_window | Pane |
| 11 | `Ctrl+Alt+1..9` | select_window N | Pane |
| 12 | `Ctrl+Alt+p` | focus_visible_window | Pane |
| 13 | `Ctrl+Alt+z` | toggle_maximize_window | Pane |
| 14 | `Ctrl+Shift+→` | next_tab | Tab |
| 15 | `Ctrl+Shift+←` | previous_tab | Tab |
| 16 | `Ctrl+Shift+l` | next_tab (Vim style) | Tab |
| 17 | `Ctrl+Shift+h` | previous_tab (Vim style) | Tab |
| 18 | `Ctrl+Shift+1..9` | goto_tab N | Tab |
| 19 | `Ctrl+Shift+p` | toggle_tab | Tab |
| 20 | `Ctrl+Shift+t` | set_tab_title | Tab |

---

## Layout 1: `splits` (Default)

**Description**: Free-form splits, similar to TMUX. Windows can be arranged in any direction.

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 1a | `Ctrl+Alt+→/←/↑/↓` | Focus moves in arrow direction | [ ] |
| 1b | `Ctrl+Alt+h/j/k/l` | Focus moves in Vim direction | [ ] |
| 1c | `Ctrl+Alt+.` | Focus cycles to next window | [ ] |
| 1d | `Ctrl+Alt+,` | Focus cycles to previous window | [ ] |
| 1e | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 1f | `Ctrl+Alt+p` | Toggles to last active window | [ ] |
| 1g | `Ctrl+Alt+z` | Maximizes / restores window | [ ] |
| 1h | `Ctrl+Shift+→/←` | Switches tabs | [ ] |
| 1i | `Ctrl+Shift+h/l` | Switches tabs (Vim style) | [ ] |
| 1j | `Ctrl+Shift+1..9` | Jumps to tab by index | [ ] |
| 1k | `Ctrl+Shift+p` | Toggles last active tab | [ ] |
| 1l | `Ctrl+Shift+t` | Prompts to rename tab | [ ] |

**Notes**: In `splits` layout, all directional focus operations should work intuitively since windows have clear spatial relationships.

---

## Layout 2: `tall`

**Description**: One main window on the left (larger), remaining windows stacked vertically on the right.

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 2a | `Ctrl+Alt+→/←/↑/↓` | Focus moves in arrow direction | [ ] |
| 2b | `Ctrl+Alt+h/j/k/l` | Focus moves in Vim direction | [ ] |
| 2c | `Ctrl+Alt+.` | Focus cycles through windows | [ ] |
| 2d | `Ctrl+Alt+,` | Focus cycles backward | [ ] |
| 2e | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 2f | `Ctrl+Alt+p` | Toggles to last active window | [ ] |
| 2g | `Ctrl+Alt+z` | Maximizes / restores window | [ ] |
| 2h | Tab shortcuts | Same as above | [ ] |

**Notes**: `focus_right` from main pane goes to right column. `focus_up/focus_down` navigates the right column stack.

---

## Layout 3: `fat`

**Description**: One main window on top (larger), remaining windows stacked horizontally at the bottom.

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 3a | `Ctrl+Alt+→/←/↑/↓` | Focus moves in arrow direction | [ ] |
| 3b | `Ctrl+Alt+h/j/k/l` | Focus moves in Vim direction | [ ] |
| 3c | `Ctrl+Alt+.` | Focus cycles through windows | [ ] |
| 3d | `Ctrl+Alt+,` | Focus cycles backward | [ ] |
| 3e | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 3f | `Ctrl+Alt+z` | Maximizes / restores window | [ ] |
| 3g | Tab shortcuts | Same as above | [ ] |

**Notes**: `focus_down` from main pane goes to bottom row. `focus_left/focus_right` navigates the bottom row.

---

## Layout 4: `grid`

**Description**: All windows arranged in a grid with approximately equal sizing.

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 4a | `Ctrl+Alt+→/←/↑/↓` | Focus moves in arrow direction | [ ] |
| 4b | `Ctrl+Alt+h/j/k/l` | Focus moves in Vim direction | [ ] |
| 4c | `Ctrl+Alt+.` | Focus cycles through all windows | [ ] |
| 4d | `Ctrl+Alt+,` | Focus cycles backward | [ ] |
| 4e | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 4f | `Ctrl+Alt+z` | Maximizes / restores window | [ ] |
| 4g | Tab shortcuts | Same as above | [ ] |

**Notes**: In `grid` layout, `focus_left/right/up/down` navigates relative to the grid cell position. Index selection (`Ctrl+Alt+N`) is particularly useful here.

---

## Layout 5: `vertical`

**Description**: All windows stacked vertically (one above the other).

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 5a | `Ctrl+Alt+↑/↓` | Focus moves up/down | [ ] |
| 5b | `Ctrl+Alt+→/←` | No-op (no horizontal neighbors) | [ ] |
| 5c | `Ctrl+Alt+k/j` | Focus moves up/down (Vim style) | [ ] |
| 5d | `Ctrl+Alt+h/l` | No-op (no horizontal neighbors) | [ ] |
| 5e | `Ctrl+Alt+.` | Focus cycles sequentially | [ ] |
| 5f | `Ctrl+Alt+,` | Focus cycles backward | [ ] |
| 5g | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 5h | Tab shortcuts | Same as above | [ ] |

**Notes**: Horizontal navigation (`left/right/h/l`) has no effect since windows are only stacked vertically. This is expected behavior.

---

## Layout 6: `horizontal`

**Description**: All windows arranged side by side horizontally.

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 6a | `Ctrl+Alt+→/←` | Focus moves left/right | [ ] |
| 6b | `Ctrl+Alt+↑/↓` | No-op (no vertical neighbors) | [ ] |
| 6c | `Ctrl+Alt+h/l` | Focus moves left/right (Vim) | [ ] |
| 6d | `Ctrl+Alt+j/k` | No-op (no vertical neighbors) | [ ] |
| 6e | `Ctrl+Alt+.` | Focus cycles sequentially | [ ] |
| 6f | `Ctrl+Alt+,` | Focus cycles backward | [ ] |
| 6g | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 6h | Tab shortcuts | Same as above | [ ] |

**Notes**: Vertical navigation (`up/down/j/k`) has no effect since windows are only side by side. This is expected.

---

## Layout 7: `stack`

**Description**: All windows stacked on top of each other (tab-like, only the active window is visible).

| # | Shortcut | Expected Result | Pass? |
|---|----------|-----------------|-------|
| 7a | `Ctrl+Alt+→/←/↑/↓` | No-op (windows are overlapped) | [ ] |
| 7b | `Ctrl+Alt+h/j/k/l` | No-op (windows are overlapped) | [ ] |
| 7c | `Ctrl+Alt+.` | Focus cycles to next window in stack | [ ] |
| 7d | `Ctrl+Alt+,` | Focus cycles to previous in stack | [ ] |
| 7e | `Ctrl+Alt+1..9` | Focus jumps to window by index | [ ] |
| 7f | `Ctrl+Alt+p` | Toggles to last active window | [ ] |
| 7g | `Ctrl+Shift+→/←` | Switches tabs | [ ] |

**Notes**: In `stack` layout, only one window is visible at a time. Directional navigation has no meaningful spatial behavior — use sequential (`next_window`/`previous_window`) or index (`select_window N`) navigation instead.

---

## Summary Checklist

| Layout | Directional Arrows | Vim-style (hjkl) | Sequential (./,) | Index (1-9) | Last Win (p) | Maximize (z) | Tabs (Shift) | Tab Index | Tab Toggle | Rename Tab |
|--------|-------------------|-------------------|------------------|-------------|--------------|--------------|--------------|-----------|------------|------------|
| splits | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| tall   | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| fat    | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| grid   | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| vertical | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| horizontal | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| stack  | [ ] N/A | [ ] N/A | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |

> **N/A** = Directional navigation has no meaningful effect in this layout (expected behavior).

---

## Known Conflicts / Observations

### Redundant Keybindings (Harmless — same action)
The following shortcuts are mapped to the same action in multiple files, which is redundant but not harmful (Kitty uses last-wins):
- `Ctrl+Alt+right` → `focus_right` (tmux-prefix.conf + navigation.conf)
- `Ctrl+Alt+left` → `focus_left` (tmux-prefix.conf + navigation.conf)
- `Ctrl+Alt+up` → `focus_up` (tmux-prefix.conf + navigation.conf)
- `Ctrl+Alt+down` → `focus_down` (tmux-prefix.conf + navigation.conf)

### Overridden Keybindings (May Need Attention)
These shortcuts in `tmux-prefix.conf` are overridden by later definitions:
- `Ctrl+Alt+right` originally `launch --location=hsplit` (line 22) → overridden by `focus_right` (line 27)
- `Ctrl+Alt+down` originally `launch --location=vsplit` (line 23) → overridden by `focus_down` (line 30)

**Impact**: Split creation via `Ctrl+Alt+right`/`Ctrl+Alt+down` does NOT work. Use `Ctrl+Alt+5` (`hsplit`) and `Ctrl+Alt+-` (`vsplit`) instead.

### `ctrl+shift+c` Conflict (scrollback.conf)
- Line 34: `select_from_cursor`
- Line 41: `copy_to_clipboard`
- **Last-wins**: `copy_to_clipboard` is active. `select_from_cursor` is inaccessible.

---

## Preparation Steps Before Testing

1. Start kitty with current config:
   ```bash
   kitty --config ~/.config/kitty/kitty.conf
   ```

2. Create test windows:
   - `Ctrl+Shift+Enter` (3-4 times) to create multiple windows
   - `Ctrl+Alt+Enter` (3 times) to create multiple tabs

3. Cycle layouts with `Ctrl+Alt+Space` to test each of the 7 layouts

4. Validate config syntax (headless):
   ```bash
   kitty +runpy "from kitty.config import load_config; load_config('$HOME/.config/kitty/kitty.conf'); print('OK')"
   ```
