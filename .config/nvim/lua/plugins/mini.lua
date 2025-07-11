return {
	-- mini.nvim
	{ "echasnovski/mini.nvim", version = false },

	-- mini.files
	{
		"echasnovski/mini.files",
		opts = function(_, opts)
			opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
				close = "<esc>",
				go_in = "l",
				go_in_plus = "<CR>",
				go_out = "H",
				go_out_plus = "h",
				reset = "<BS>",
				reveal_cwd = ".",
				show_help = "g?",
				synchronize = "s",
				trim_left = "<",
				trim_right = ">",
			})

			opts.custom_keymaps = {
				open_tmux_pane = "<M-t>",
				copy_to_clipboard = "<space>yy",
				zip_and_copy = "<space>yz",
				paste_from_clipboard = "<space>p",
				copy_path = "<M-c>",
				preview_image = "<space>i",
				preview_image_popup = "<M-i>",
			}

			opts.windows = vim.tbl_deep_extend("force", opts.windows or {}, {
				preview = true,
				width_focus = 30,
				width_preview = 80,
			})

			opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
				use_as_default_explorer = true,
				permanent_delete = false,
			})
			return opts
		end,
		keys = {
			{
				"<leader>e",
				function()
					local buf_name = vim.api.nvim_buf_get_name(0)
					local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
					if vim.fn.filereadable(buf_name) == 1 then
						require("mini.files").open(buf_name, true)
					elseif vim.fn.isdirectory(dir_name) == 1 then
						require("mini.files").open(dir_name, true)
					else
						require("mini.files").open(vim.uv.cwd(), true)
					end
				end,
				desc = "Open mini.files (Directory of Current File or CWD if not exists)",
			},
			{
				"<leader>E",
				function()
					require("mini.files").open(vim.uv.cwd(), true)
				end,
				desc = "Open mini.files (cwd)",
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)
			-- Assuming mini_files_km and mini_files_git are defined elsewhere or removed if not needed.
			-- If they are not needed, remove the following lines:
			-- mini_files_km.setup(opts)
			-- mini_files_git.setup()
		end,
	},

	-- mini.indentscope
	{
		"echasnovski/mini.indentscope",
		version = false,
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"mason",
					"notify",
					"toggleterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},

	-- mini.pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			skip_ts = { "string" },
			skip_unbalanced = true,
			markdown = true,
			mappings = {
				["`"] = false,
			},
		},
	},

	-- mini.surround
	{
		"echasnovski/mini.surround",
		keys = function(_, keys)
			local opts = require("mini.surround").config
			local mappings = {
				{ opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
				{ opts.mappings.delete, desc = "Delete Surrounding" },
				{ opts.mappings.find, desc = "Find Right Surrounding" },
				{ opts.mappings.find_left, desc = "Find Left Surrounding" },
				{ opts.mappings.highlight, desc = "Highlight Surrounding" },
				{ opts.mappings.replace, desc = "Replace Surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
	},
}
