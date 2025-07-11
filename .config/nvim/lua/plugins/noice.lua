return -- lazy.nvim
{
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		messages = {
			-- NOTE: If you enable messages, then the cmdline is enabled automatically.
			-- This is a current Neovim limitation.
			enabled = true, -- enables the Noice messages UI
			view = "mini", -- default view for messages
			view_error = "mini", -- view for errors
			view_warn = "mini", -- view for warnings
			view_history = "mini", -- view for :messages
			view_search = "mini", -- view for search count messages. Set to `false` to disable
		},
		notify = {
			-- Noice can be used as `vim.notify` so you can route any notification like other messages
			-- Notification messages have their level and other properties set.
			-- event is always "notify" and kind can be any log level as a string
			-- The default routes will forward notifications to nvim-notify
			-- Benefit of using Noice for this is the routing and consistent history view
			enabled = false,
			view = "mini",
		},
		lsp = {
			message = {
				-- Messages shown by lsp servers
				enabled = true,
				view = "mini",
			},
		},
		views = {
			-- This sets the position for the search popup that shows up with / or with :
			cmdline_popup = {
				position = {
					row = "40%",
					col = "50%",
				},
			},
			mini = {
				-- timeout = 5000, -- timeout in milliseconds
				timeout = vim.g.neovim_mode == "skitty" and 2000 or 5000,
				align = "center",
				position = {
					-- Centers messages top to bottom
					row = "95%",
					-- Aligns messages to the far right
					col = "100%",
				},
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
}
