return {
	-- Using Lazy
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "darker",
				transparent = false,
			})
			-- Enable theme
			-- require("onedark").load()
		end,
	},
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("everforest").setup({
				background = "hard",
				transparent_background_level = 0,
				italics = false,
				disable_italic_comments = false,
				sign_column_background = "none",
				ui_contrast = "low",
				dim_inactive_windows = false,
				diagnostic_text_highlight = false,
				diagnostic_virtual_text = "coloured",
				diagnostic_line_highlight = false,
				spell_foreground = false,
				show_eob = true,
				float_style = "bright",
				inlay_hints_background = "none",
				---@param highlight_groups Highlights
				---@param palette Palette
				on_highlights = function(highlight_groups, palette) end,
				---@param palette Palette
				colours_override = function(palette) end,
			})
		end,
	},
	{
		-- lua/plugins/rose-pine.lua
		"rose-pine/neovim",
		name = "rose-pine-moon",
		config = function()
			require("rose-pine").setup({
				dark_variant = "moon", -- main, moon, or dawn
				styles = {
					bold = true,
					italic = true,
					transparency = false,
				},
			})
			-- vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			-- Default options:
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors) -- add/modify highlights
					return {
						["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
						["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
						["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
						["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
						["@markup.list.markdown"] = { link = "Function" }, -- + list
						["@markup.quote.markdown"] = { link = "Error" }, -- > blockcode
					}
				end,
				theme = "wave", -- Load "wave" theme
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					-- light = "lotus"
				},
			})

			-- vim.cmd("colorscheme kanagawa") -- setup must be called before loading
		end,
		-- build = function()
		--   vim.cmd("KanagawaCompile")
		-- end,
	},
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			-- custom options here
		},
		config = function(_, opts)
			require("tokyodark").setup(opts) -- calling setup is optional
			-- vim.cmd([[colorscheme tokyodark]])
		end,
	},
	{
		"loctvl842/monokai-pro.nvim",
		-- config = function()
		-- 	require("monokai-pro").setup()
		-- end,
		opts = {
			transparent_background = false,
			terminal_colors = true,
			devicons = true, -- highlight the icons of `nvim-web-devicons`
			styles = {
				comment = { italic = true },
				keyword = { italic = true }, -- any other keyword
				type = { italic = true }, -- (preferred) int, long, char, etc
				storageclass = { italic = true }, -- static, register, volatile, etc
				structure = { italic = true }, -- struct, union, enum, etc
				parameter = { italic = true }, -- parameter pass in function
				annotation = { italic = true },
				tag_attribute = { italic = true }, -- attribute of tag in reactjs
			},
			filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
			-- Enable this will disable filter option
			day_night = {
				enable = false, -- turn off by default
				day_filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
				night_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
			},
			inc_search = "background", -- underline | background
			background_clear = {
				-- "float_win",
				"toggleterm",
				"telescope",
				-- "which-key",
				"renamer",
				"notify",
				-- "nvim-tree",
				-- "neo-tree",
				-- "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
			}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
			plugins = {
				bufferline = {
					underline_selected = false,
					underline_visible = false,
				},
				indent_blankline = {
					context_highlight = "default", -- default | pro
					context_start_underline = false,
				},
			},
		},
	},
	{
		"AstroNvim/astrotheme",
		opts = {

			palette = "astrodark", -- String of the default palette to use when calling `:colorscheme astrotheme`
			background = { -- :h background, palettes to use when using the core vim background colors
				light = "astrolight",
				dark = "astrodark",
			},

			style = {
				transparent = false, -- Bool value, toggles transparency.
				inactive = true, -- Bool value, toggles inactive window color.
				float = true, -- Bool value, toggles floating windows background colors.
				neotree = true, -- Bool value, toggles neo-trees background color.
				border = true, -- Bool value, toggles borders.
				title_invert = true, -- Bool value, swaps text and background colors.
				italic_comments = true, -- Bool value, toggles italic comments.
				simple_syntax_colors = true, -- Bool value, simplifies the amounts of colors used for syntax highlighting.
			},

			termguicolors = true, -- Bool value, toggles if termguicolors are set by AstroTheme.

			terminal_color = true, -- Bool value, toggles if terminal_colors are set by AstroTheme.

			plugin_default = "auto", -- Sets how all plugins will be loaded
			-- "auto": Uses lazy / packer enabled plugins to load highlights.
			-- true: Enables all plugins highlights.
			-- false: Disables all plugins.

			plugins = { -- Allows for individual plugin overrides using plugin name and value from above.
				["bufferline.nvim"] = false,
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = { -- use the night style
			style = "storm",
			-- disable italic for functions
			styles = {
				functions = {},
			},
			-- Change the "hint" color to the "orange" color, and make the "error" color bright red
			on_colors = function(colors)
				colors.hint = colors.orange
				colors.error = "#ff0000"
			end,
			on_highlights = function(hl, c)
				local prompt = "#2d3149"
				hl.TelescopeNormal = {
					bg = c.bg_dark,
					fg = c.fg_dark,
				}
				hl.TelescopeBorder = {
					bg = c.bg_dark,
					fg = c.bg_dark,
				}
				hl.TelescopePromptNormal = {
					bg = prompt,
				}
				hl.TelescopePromptBorder = {
					bg = prompt,
					fg = prompt,
				}
				hl.TelescopePromptTitle = {
					bg = prompt,
					fg = prompt,
				}
				hl.TelescopePreviewTitle = {
					bg = c.bg_dark,
					fg = c.bg_dark,
				}
				hl.TelescopeResultsTitle = {
					bg = c.bg_dark,
					fg = c.bg_dark,
				}
			end,
		},
	},
}
