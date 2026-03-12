local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ============================================================================
-- CONFIGURAÇÕES GLOBAIS (Windows + Linux)
-- ============================================================================
config.keys = {
	{ key = "F12", mods = "NONE", action = wezterm.action.ActivateCommandPalette },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.ScrollToPrompt(1) },
	{ key = "x", mods = "ALT", action = wezterm.action.ActivateCopyMode },
	-- Split pane bindings (tmux-like)
	{ key = "s", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical },
	{ key = "v", mods = "ALT|SHIFT", action = wezterm.action.SplitHorizontal },
	-- Pane navigation (tmux-like)
	{ key = "LeftArrow", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
	-- Close current pane (Alt+Shift+W to avoid closing tab with Ctrl+Shift+W)
	{ key = "w", mods = "ALT|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
}

-- ===== Command Palette =====
local act = wezterm.action

wezterm.on("augment-command-palette", function(window, pane)
	return {
		{
			brief = "Rename tab",
			icon = "md_rename_box",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				initial_value = window:active_tab():get_title(),
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	}
end)

-- ===== Fonte e Cores =====
config.font_size = 12
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"AdwaitaMono Nerd Font Mono",
	"Iosevka Nerd Font",
	"ShureTechMono Nerd Font Mono",
	"Maple Mono NF",
	"DMMono Nerd Font",
	"CommitMono Nerd Font",
	"FiraCode Nerd Font",
})

config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
}
config.force_reverse_video_cursor = true

local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- ===== Background Opcional =====
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

-- ===== Janela / UI (Ajustado para Niri) =====
-- window_decorations = "NONE" - disables titlebar and border (borderless mode), but causes problems with resizing and minimizing the window, so you probably want to use RESIZE instead of NONE if you just want to remove the title bar.
-- window_decorations = "TITLE" - disable the resizable border and enable only the title bar
-- window_decorations = "RESIZE" - disable the title bar but enable the resizable border
-- window_decorations = "TITLE | RESIZE" - Enable titlebar and border. This is the default.
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- 1. Zere o padding ou use valores simétricos para testar.
-- Recomendo 0 para isolar o problema de geometria primeiro.
-- config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.window_close_confirmation = "NeverPrompt"

-- 2. REMOVA OU COMENTE ESTAS LINHAS:
-- config.initial_cols = 95  <-- ISSO QUEBRA O NIRI
-- config.initial_rows = 28  <-- ISSO QUEBRA O NIRI

-- 3. ESSENCIAL: Impede que o WezTerm tente redimensionar a si mesmo
config.use_resize_increments = false
config.adjust_window_size_when_changing_font_size = false

-- ... (Performance / Cursor igual)

-- ====== LINUX ======
if wezterm.target_triple:find("linux") then
	config.enable_wayland = false

	-- Se o problema persistir, force a renderização WebGpu (mais estável no Wayland atual)
	config.front_end = "WebGpu"

	config.prefer_to_spawn_tabs = false
	config.window_decorations = "NONE"
-- ====== WINDOWS ======
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- Decorações de janela
	config.window_decorations = "RESIZE"
	config.use_fancy_tab_bar = false
	config.initial_rows = 35
	config.initial_cols = 120

	-- -- Ordem de fontes no Windows
	-- config.font = wezterm.font_with_fallback({
	--    "JetBrainsMono Nerd Font",
	-- 	"DMMono Nerd Font",
	-- 	"Maple Mono NF",
	-- 	"SauceCodePro NF",
	-- })

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
config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Operator Mono Dark"
config.color_scheme = "Catppuccin Macchiato"
--]]
config.color_scheme = "Dracula (Official)"

return config
