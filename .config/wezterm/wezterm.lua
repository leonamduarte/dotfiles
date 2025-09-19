local wezterm = require("wezterm")
local config = wezterm.config_builder()
local opacity = 1
-- local theme = require("lua/rose-pine").moon

-- Font settings
config.font_size = 13
-- config.line_height = 1.1
-- config.font = wezterm.font("GeistMono Nerd Font")
-- config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("BlexMono Nerd Font")
config.font = wezterm.font("DMMono Nerd Font")
-- config.font = wezterm.font("AdwaitaMono Nerd Font")
-- config.font = wezterm.font("SauceCodePro Nerd Font")

-- config.font = wezterm.font("MesloLGS Nerd Font Mono")
-- color_scheme
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}
-- config.color_scheme = require("cyberdream")
-- config.color_scheme = require("Eldritch")
-- config.color_scheme = "Eldritch"
-- or Macchiato, Frappe, Latte
config.color_scheme = "Catppuccin Macchiato"
-- config.colors = theme.colors()
-- needed only if using fancy tab bar
-- config.window_frame = theme.window_frame()
config.force_reverse_video_cursor = true

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
config.enable_wayland = true

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true
config.default_cursor_style = "SteadyBar"
-- Custom commands

if wezterm.target_triple:find("windows") then
	config.default_prog = { "pwsh.exe" }
else
	-- Run fastfetch first, then execute fish
	config.default_prog = { "/bin/sh", "-c", "fastfetch; exec fish" }
end

config.window_close_confirmation = "NeverPrompt"

--- Get the current operating system
--- @return "windows"| "linux" | "macos"
local function get_os()
	local bin_format = package.cpath:match("%p[\\|/]?%p(%a+)")
	if bin_format == "dll" then
		return "windows"
	elseif bin_format == "so" then
		return "linux"
	end

	return "macos"
end

local host_os = get_os()

-- Window Configuration
config.initial_rows = 35
config.initial_cols = 120
config.window_decorations = "RESIZE"
config.window_background_opacity = opacity
config.window_background_image = (os.getenv("WEZTERM_CONFIG_FILE") or ""):gsub("wezterm.lua", "bg-blurred.png")
config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Acrylic"

config.window_background_opacity = 1
-- Performance Settings
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250

-- Tab Bar Configuration
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false

-- Keybindings
config.keys = {
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

-- Default Shell Configuration
config.default_prog = {
	"C:\\Windows\\System32\\cmd.exe",
	"--login",
	"-i",
}

-- OS-Specific Overrides
if host_os == "linux" then
	config.default_prog = { "zsh" }
	config.front_end = "WebGpu"
	-- config.window_background_image = os.getenv("HOME") .. "/.config/wezterm/assets/bg-blurred.png"
	config.window_decorations = "NONE" -- use system decorations
end

return config
