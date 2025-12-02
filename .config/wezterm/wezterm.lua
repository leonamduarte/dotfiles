local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ===== Fonte e cores =====
config.font_size = 13
config.font = wezterm.font_with_fallback({
	"Liga SFMono Nerd Font",
	"AdwaitaMono Nerd Font",
	"JetBrainsMono Nerd Font",
	"Maple Mono",
	"DM Mono",
	"CaskaydiaCove Nerd Font",
	"FiraCode Nerd Font",
})

-- config.color_scheme = "Operator Mono Dark"
-- config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato (Gogh)"
-- config.color_scheme = "Catppuccin Macchiato"
config.color_scheme = "Eldritch"

config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}
config.force_reverse_video_cursor = true

-- ===== Janela / UI =====
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
-- config.enable_tab_bar = false
-- config.show_tab_index_in_tab_bar = false
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

-- ===== Linux/Wayland =====
config.enable_wayland = true
config.prefer_egl = true

-- ===== Shell padrão (sempre zsh) =====
-- config.default_prog = { "zsh", "-l" }

-- ===== Atalhos =====
config.keys = {
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.window_decorations = "RESIZE"
	config.use_fancy_tab_bar = false

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
	local bg_flag = true
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
end

return config
