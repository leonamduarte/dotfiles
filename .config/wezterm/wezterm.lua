local wezterm = require("wezterm")
local config = wezterm.config_builder()
local constants = require("constants")
local toggle_transparency_command = require("commands.toggle-transparency")
-- Initialize Configuration
local opacity = 1
local transparent_bg = "rgba(22, 24, 26, " .. opacity .. ")"

-- Font settings
config.font_size = 13
-- config.line_height = 1.3
-- config.font = wezterm.font("SpaceMono Nerd Font Mono")
-- config.font = wezterm.font("BlexMono Nerd Font Mono")
-- config.font = wezterm.font("0xProto Nerd Font Mono")
config.font = wezterm.font("DMMono Nerd Font")
-- config.font = wezterm.font("IosevkaTerm NF")

-- Colors
-- config.colors = {
-- 	cursor_bg = "white",
-- 	cursor_border = "white",
-- }

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
-- config.default_cursor_style = "SteadyBar"
-- Custom commands

wezterm.on("augment-command-palette", function()
	return {
		toggle_transparency = toggle_transparency_command,
	}
end)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- Configuração para Windows
	config.default_prog = { "pwsh" }
else
	-- Configuração para Linux (e outros sistemas)
	config.default_prog = { "fish" }
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

-- Color Configuration
config.colors = require("cyberdream")
config.force_reverse_video_cursor = true

-- Window Configuration
config.initial_rows = 45
config.initial_cols = 180
config.window_decorations = "RESIZE"
config.window_background_opacity = opacity
config.window_background_image = (os.getenv("WEZTERM_CONFIG_FILE") or ""):gsub("wezterm.lua", "bg-blurred.png")
config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Acrylic"

-- Performance Settings
config.max_fps = 144
config.animation_fps = 60
-- config.cursor_blink_rate = 250

-- Tab Bar Configuration
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false
config.colors.tab_bar = {
	background = config.window_background_image and "rgba(0, 0, 0, 0)" or transparent_bg,
	new_tab = { fg_color = config.colors.background, bg_color = config.colors.brights[6] },
	new_tab_hover = { fg_color = config.colors.background, bg_color = config.colors.foreground },
}

-- Tab Formatting
-- wezterm.on("format-tab-title", function(tab, _, _, _, hover)
-- 	local background = config.colors.brights[1]
-- 	local foreground = config.colors.foreground
--
-- 	if tab.is_active then
-- 		background = config.colors.brights[7]
-- 		foreground = config.colors.background
-- 	elseif hover then
-- 		background = config.colors.brights[8]
-- 		foreground = config.colors.background
-- 	end
--
-- 	local title = tostring(tab.tab_index + 1)
-- 	return {
-- 		{ Foreground = { Color = background } },
-- 		{ Text = "█" },
-- 		{ Background = { Color = background } },
-- 		{ Foreground = { Color = foreground } },
-- 		{ Text = title },
-- 		{ Foreground = { Color = background } },
-- 		{ Text = "█" },
-- 	}
-- end)

-- Keybindings
config.keys = {
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

-- Default Shell Configuration
config.default_prog = { "pwsh", "-NoLogo" }

-- OS-Specific Overrides
if host_os == "linux" then
	config.default_prog = { "fish" }
	config.front_end = "WebGpu"
	config.window_background_image = os.getenv("HOME") .. "/.config/wezterm/bg-blurred.png"
	config.window_decorations = nil -- use system decorations
end

return config
