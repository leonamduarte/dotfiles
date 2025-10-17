local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ===== Fonte e cores =====
config.font_size = 12
config.font = wezterm.font("FiraCode Nerd Font")

config.color_scheme = "One Dark (Gogh)"

config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}
config.force_reverse_video_cursor = true

-- ===== Janela / UI =====
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false
config.window_padding = { left = 5, right = 0, top = 5, bottom = 0 }

config.initial_rows = 35
config.initial_cols = 120
config.window_close_confirmation = "NeverPrompt"

-- ===== Desempenho / Cursor =====
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 250
config.default_cursor_style = "SteadyBar"

-- ===== Linux/Wayland =====
config.enable_wayland = true
config.prefer_egl = true

-- ===== Shell padrão (sempre zsh) =====
config.default_prog = { "zsh", "-l" }

-- ===== Atalhos =====
config.keys = {
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

return config
