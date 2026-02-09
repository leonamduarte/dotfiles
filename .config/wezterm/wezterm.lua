local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ============================================================================
-- CONFIGURAÇÕES GLOBAIS (Windows + Linux)
-- ============================================================================

-- ===== Fonte e Cores =====
config.font_size = 13
config.font = wezterm.font_with_fallback({
	"DMMono Nerd Font",
	"Maple Mono NF",
	"JetBrainsMono Nerd Font",
	"FiraCode Nerd Font",
})

config.color_scheme = "OneDark (base16)"
-- config.color_scheme = "Eldritch"
-- config.color_scheme = "One Dark (Gogh)"
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}
config.force_reverse_video_cursor = true

-- config.background = {
-- 	{
-- 		source = {
-- 			Gradient = {
-- 				orientation = "Vertical",
-- 				colors = {
-- 					-- "#16161e",
-- 					-- "#1a0f2e",
-- 					-- "#0a1a1f",
-- 					-- "#0f1a26",
-- 					-- "#011628",
-- 				},
-- 			},
-- 		},
-- 		width = "100%",
-- 		height = "100%",
-- 	},
-- }

local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- ===== Background Opcional =====
local bg_flag = false
if bg_flag then
	local cfg = os.getenv("WEZTERM_CONFIG_FILE")
	if cfg then
		local bg = cfg:gsub("wezterm.lua", "bg-blurred.png")
		if file_exists(bg) then
			config.window_background_image = bg
			config.window_background_opacity = 1.0
		end
	end
end

-- ===== Janela / UI =====
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_padding = { left = 5, right = 0, top = 5, bottom = 0 }
config.initial_rows = 35
config.initial_cols = 120
config.window_close_confirmation = "NeverPrompt"

-- ===== Desempenho / Cursor =====
config.max_fps = 120
config.animation_fps = 60
config.default_cursor_style = "SteadyBar"

-- ===== Atalhos =====
config.keys = {
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

-- ============================================================================
-- CONFIGURAÇÕES ESPECÍFICAS POR SISTEMA OPERACIONAL
-- ============================================================================

-- ====== LINUX ======
if wezterm.target_triple:find("linux") then
	-- Wayland/EGL
	config.enable_wayland = true
	config.prefer_egl = true

	-- Comportamento de janelas (evita mensagem de spawn)
	config.prefer_to_spawn_tabs = false

	-- Shell padrão (descomente se necessário)
	-- config.default_prog = { "zsh", "-l" }

	-- Mantém decorações no Linux (ou use "NONE" se preferir)
	config.window_decorations = "NONE"

-- ====== WINDOWS ======
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- Decorações de janela
	config.window_decorations = "RESIZE"
	config.use_fancy_tab_bar = false

	-- Ordem de fontes no Windows
	config.font = wezterm.font_with_fallback({
		"DMMono Nerd Font",
		"JetBrainsMono Nerd Font",
		"Maple Mono NF",
		"SauceCodePro NF",
	})
	-- ===== Background Opcional =====
	bg_flag = false
	if bg_flag then
		local cfg = os.getenv("WEZTERM_CONFIG_FILE")
		if cfg then
			local bg = cfg:gsub("wezterm.lua", "bg-blurred.png")
			if file_exists(bg) then
				config.window_background_image = bg
				config.window_background_opacity = 1.0
			end
		end
	end

	-- ===== Shell Padrão: Git Bash (com fallback) =====
	do
		local candidates = {
			"C:\\Program Files\\Git\\usr\\bin\\bash.exe",
			"C:\\Program Files\\Git\\bin\\bash.exe",
			"C:\\Program Files (x86)\\Git\\usr\\bin\\bash.exe",
			"C:\\Program Files (x86)\\Git\\bin\\bash.exe",
		}

		local shell
		for _, p in ipairs(candidates) do
			if file_exists(p) then
				shell = p
				break
			end
		end

		if not shell then
			-- Fallback para PowerShell
			config.default_prog = { "powershell.exe", "-NoLogo" }
		else
			if shell:match("git%-bash%.exe$") then
				config.default_prog = { shell }
			else
				config.default_prog = { shell, "--login", "-i" }
			end
		end
	end

	-- Diretório inicial
	config.default_cwd = os.getenv("USERPROFILE") or "C:\\"
end

-- ============================================================================
-- TEMAS COMENTADOS (para referência rápida)
-- ============================================================================
--[[
config.color_scheme = "Operator Mono Dark"
config.color_scheme = "Astrodark (Gogh)"
config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Kanagawa (Gogh)"
config.color_scheme = "Tomorrow Night Blue"
config.color_scheme = "Cobalt 2 (Gogh)"
config.color_scheme = "Catppuccin Macchiato (Gogh)"
config.color_scheme = "Eldritch"
config.color_scheme = "Catppuccin Macchiato"
--]]

return config
