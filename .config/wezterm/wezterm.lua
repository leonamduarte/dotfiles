-- wezterm.lua (Windows-only, Git Bash como padrão)
local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- ===== Aparência básica =====
config.font = wezterm.font_with_fallback({
	"CaskaydiaCove Nerd Font",
	"JetBrainsMono Nerd Font",
	"FiraCode Nerd Font",
	"Space Grotesk",
})
config.font_size = 13
config.color_scheme = "Catppuccin Macchiato"
-- config.colors = require("cyberdream")
-- config.color_scheme = "Oxocarbon Dark (Gogh)"
-- config.color_scheme = "Rosé Pine Moon (Gogh)"
-- config.colors = {
-- 	cursor_bg = "white",
-- 	cursor_border = "white",
-- }
-- config.force_reverse_video_cursor = true

config.window_decorations = "RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true
-- config.enable_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.default_cursor_style = "SteadyBar"

-- config.initial_rows = 35
-- config.initial_cols = 120
config.max_fps = 144
config.animation_fps = 60
-- config.cursor_blink_rate = 250

-- Segurar a janela enquanto você depura RCs do bash.
-- Troque para "CloseOnCleanExit" quando estiver tudo OK.
config.exit_behavior = "Hold"
config.window_close_confirmation = "NeverPrompt"

-- ===== Util =====
local function file_exists(p)
	local f = io.open(p, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- Background opcional (somente se existir no mesmo diretório do config)
-- altere bg_flag para = true para ativar
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

-- ===== Shell padrão: Git Bash (com fallback) =====
do
	-- Ordem de preferência: git-bash.exe (prepara MSYS) -> bash.exe
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
		-- Fallback para não quebrar
		config.default_prog = { "powershell.exe", "-NoLogo" }
	else
		if shell:match("git%-bash%.exe$") then
			-- git-bash.exe já inicializa ambiente MSYS/MinGW
			config.default_prog = { shell }
		else
			-- bash.exe direto: garante login + interativo (carrega perfis)
			config.default_prog = { shell, "--login", "-i" }
		end
	end
end

-- (Opcional) iniciar no HOME do usuário
config.default_cwd = os.getenv("USERPROFILE") or "C:\\"

-- ===== Atalhos =====
config.keys = {
	{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
}

-- ===== Coisas específicas do Windows =====
-- config.win32_system_backdrop = "Acrylic"

return config
