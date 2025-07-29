local wezterm = require("wezterm")
local config = wezterm.config_builder()
local constants = require("constants")
local toggle_transparency_command = require("commands.toggle-transparency")

-- Font settings
config.font_size = 13
-- config.line_height = 1.3
-- config.font = wezterm.font("0xProto Nerd Font Mono")
-- config.font = wezterm.font("DMMono Nerd Font")
config.font = wezterm.font("SpaceMono Nerd Font")

-- Colors
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}

-- Appearance
-- config.window_decorations = "NONE"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_image = constants.bg_image

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true

-- Custom commands

wezterm.on("augment-command-palette", function()
	return {
		toggle_transparency = toggle_transparency_command,
	}
end)

return config
