return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
      open_preview = {
        vertical = true,
        horizontal = false,
        split = "botright",
      },
    },
    config = function()
      require("oil").setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
          "icon",
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        -- Buffer-local options to use for oil buffers
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = false,
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = false,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        -- Oil will automatically delete hidden buffers after this delay
        -- You can set the delay to false to disable cleanup entirely
        -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          -- Enable or disable LSP file operations
          enabled = true,
          -- Time to wait for LSP file operations to complete before skipping
          timeout_ms = 1000,
          -- Set to true to autosave buffers that are updated with LSP willRenameFiles
          -- Set to "unmodified" to only save unmodified buffers
          autosave_changes = false,
        },
        -- Constrain the cursor to the editable parts of the oil buffer
        -- Set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = "editable",
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["q"] = { "actions.close", mode = "n" },
          ["<C-l>"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            local m = name:match("^%.")
            return m ~= nil
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
          -- Sort file names with numbers in a more intuitive order for humans.
          -- Can be "fast", true, or false. "fast" will turn it off for large directories.
          natural_order = "fast",
          -- Sort file and directory names case insensitive
          case_insensitive = false,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { "type", "asc" },
            { "name", "asc" },
          },
          -- Customize the highlight group for the file name
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        -- Extra arguments to pass to SCP when moving/copying files over SSH
        extra_scp_args = {},
        -- EXPERIMENTAL support for performing file operations with git
        git = {
          -- Return true to automatically git add/mv/rm files
          add = function(path)
            return false
          end,
          mv = function(src_path, dest_path)
            return false
          end,
          rm = function(path)
            return false
          end,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = nil,
          -- preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = "auto",
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
        -- Configuration for the file preview window
        preview_win = {
          -- Whether the preview window is automatically updated when the cursor is moved
          update_on_cursor_moved = true,
          -- How to open the preview window "load"|"scratch"|"fast_scratch"
          preview_method = "fast_scratch",
          -- A function that returns true to disable preview on a file e.g. to avoid lag
          disable_preview = function(filename)
            return false
          end,
          -- Window-local options to use for preview window buffers
          win_options = {},
        },
        -- Configuration for the floating action confirmation window
        confirmation = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
          max_height = 0.9,
          -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
          min_height = { 5, 0.1 },
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating progress window
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = "rounded",
          minimized_border = "none",
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating SSH window
        ssh = {
          border = "rounded",
        },
        -- Configuration for the floating keymaps help window
        keymaps_help = {
          border = "rounded",
        },
      })
    end,
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} }, { "refractalize/oil-git-status.nvim" } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>lz",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current wile",
      },
      {
        -- Open in the current working directory
        "<leader>ly",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<c-.>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
      yazi_floating_window_border = "none",
    },
  },
  {
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        {
          "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
          version = "2.*",
          config = function()
            require("window-picker").setup({
              filter_rules = {
                include_current_win = false,
                autoselect_one = true,
                -- filter using buffer options
                bo = {
                  -- if the file type is one of following, the window will be ignored
                  filetype = { "neo-tree", "neo-tree-popup", "notify" },
                  -- if the buffer type is one of following, the window will be ignored
                  buftype = { "terminal", "quickfix" },
                },
              },
            })
          end,
        },
      },
      lazy = false,
      config = function()
        vim.diagnostic.config({
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "",
              [vim.diagnostic.severity.WARN] = "",
              [vim.diagnostic.severity.INFO] = "",
              [vim.diagnostic.severity.HINT] = "󰌵",
            },
          },
        })

        require("neo-tree").setup({
          close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
          popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
          enable_git_status = true,
          enable_diagnostics = true,
          open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
          open_files_using_relative_paths = false,
          sort_case_insensitive = false, -- used when sorting files and directories in the tree
          sort_function = nil, -- use a custom function for sorting files and directories in the tree
          -- sort_function = function (a,b)
          --       if a.type == b.type then
          --           return a.path > b.path
          --       else
          --           return a.type > b.type
          --       end
          --   end , -- this sorts files and directories descendantly
          default_component_configs = {
            container = {
              enable_character_fade = true,
            },
            indent = {
              indent_size = 2,
              padding = 1, -- extra padding on left hand side
              -- indent guides
              with_markers = true,
              indent_marker = "│",
              last_indent_marker = "└",
              highlight = "NeoTreeIndentMarker",
              -- expander config, needed for nesting files
              with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
              expander_collapsed = "",
              expander_expanded = "",
              expander_highlight = "NeoTreeExpander",
            },
            -- icon = {
            --   folder_closed = "",
            --   folder_open = "",
            --   folder_empty = "󰜌",
            --   provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
            --     if node.type == "file" or node.type == "terminal" then
            --       local success, web_devicons = pcall(require, "nvim-web-devicons")
            --       local name = node.type == "terminal" and "terminal" or node.name
            --       if success then
            --         local devicon, hl = web_devicons.get_icon(name)
            --         icon.text = devicon or icon.text
            --         icon.highlight = hl or icon.highlight
            --       end
            --     end
            --   end,
            --   -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            --   -- then these will never be used.
            --   default = "*",
            --   highlight = "NeoTreeFileIcon",
            -- },
            modified = {
              symbol = "[+]",
              highlight = "NeoTreeModified",
            },
            name = {
              trailing_slash = false,
              use_git_status_colors = true,
              highlight = "NeoTreeFileName",
            },
            git_status = {
              symbols = {
                -- Change type
                added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                deleted = "✖", -- this can only be used in the git_status source
                renamed = "󰁕", -- this can only be used in the git_status source
                -- Status type
                untracked = "",
                ignored = "",
                unstaged = "󰄱",
                staged = "",
                conflict = "",
              },
            },
            -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
            file_size = {
              enabled = true,
              width = 12, -- width of the column
              required_width = 64, -- min width of window required to show this column
            },
            type = {
              enabled = true,
              width = 10, -- width of the column
              required_width = 122, -- min width of window required to show this column
            },
            -- last_modified = {
            --   enabled = true,
            --   width = 20, -- width of the column
            --   required_width = 88, -- min width of window required to show this column
            -- },
            -- created = {
            --   enabled = true,
            --   width = 20, -- width of the column
            --   required_width = 110, -- min width of window required to show this column
            -- },
            symlink_target = {
              enabled = false,
            },
          },
          -- A list of functions, each representing a global custom command
          -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
          -- see `:h neo-tree-custom-commands-global`
          commands = {},
          window = {
            position = "right",
            width = 40,
            mapping_options = {
              noremap = true,
              nowait = true,
            },
            mappings = {
              ["<space>"] = {
                "toggle_node",
                nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
              },
              ["<2-LeftMouse>"] = "open",
              ["<cr>"] = "open",
              ["<esc>"] = "cancel", -- close preview or floating neo-tree window
              ["P"] = {
                "toggle_preview",
                config = {
                  use_float = true,
                  use_snacks_image = true,
                  use_image_nvim = true,
                },
              },
              -- Read `# Preview Mode` for more information
              ["l"] = "focus_preview",
              ["S"] = "open_split",
              ["s"] = "open_vsplit",
              -- ["S"] = "split_with_window_picker",
              -- ["s"] = "vsplit_with_window_picker",
              ["t"] = "open_tabnew",
              -- ["<cr>"] = "open_drop",
              -- ["t"] = "open_tab_drop",
              ["w"] = "open_with_window_picker",
              --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
              ["C"] = "close_node",
              -- ['C'] = 'close_all_subnodes',
              ["z"] = "close_all_nodes",
              --["Z"] = "expand_all_nodes",
              --["Z"] = "expand_all_subnodes",
              ["a"] = {
                "add",
                -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                config = {
                  show_path = "none", -- "none", "relative", "absolute"
                },
              },
              ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
              ["d"] = "delete",
              ["r"] = "rename",
              ["b"] = "rename_basename",
              ["y"] = "copy_to_clipboard",
              ["x"] = "cut_to_clipboard",
              ["p"] = "paste_from_clipboard",
              ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
              -- ["c"] = {
              --  "copy",
              --  config = {
              --    show_path = "none" -- "none", "relative", "absolute"
              --  }
              --}
              ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
              ["q"] = "close_window",
              ["R"] = "refresh",
              ["?"] = "show_help",
              ["<"] = "prev_source",
              [">"] = "next_source",
              ["i"] = "show_file_details",
              -- ["i"] = {
              --   "show_file_details",
              --   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
              --   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
              --   -- config = {
              --   --   created_format = "%Y-%m-%d %I:%M %p",
              --   --   modified_format = "relative", -- equivalent to the line below
              --   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
              --   -- }
              -- },
            },
          },
          nesting_rules = {},
          filesystem = {
            filtered_items = {
              visible = true, -- when true, they will just be displayed differently than normal items
              hide_dotfiles = false,
              hide_gitignored = true,
              hide_hidden = false, -- only works on Windows for hidden files/directories
              hide_by_name = {
                --"node_modules"
              },
              hide_by_pattern = { -- uses glob style patterns
                --"*.meta",
                --"*/src/*/tsconfig.json",
              },
              always_show = { -- remains visible even if other settings would normally hide it
                --".gitignored",
              },
              always_show_by_pattern = { -- uses glob style patterns
                --".env*",
              },
              never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                --".DS_Store",
                --"thumbs.db"
              },
              never_show_by_pattern = { -- uses glob style patterns
                --".null-ls_*",
              },
            },
            follow_current_file = {
              enabled = true, -- This will find and focus the file in the active buffer every time
              --               -- the current file is changed while the tree is open.
              leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            },
            group_empty_dirs = false, -- when true, empty folders will be grouped together
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",  -- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
            -- instead of relying on nvim autocmd events.
            window = {
              mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["D"] = "fuzzy_finder_directory",
                ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                -- ["D"] = "fuzzy_sorter_directory",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                ["o"] = {
                  "show_help",
                  nowait = false,
                  config = { title = "Order by", prefix_key = "o" },
                },
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["og"] = { "order_by_git_status", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
                ["\\"] = "close_window",

                -- ['<key>'] = function(state) ... end,
              },
              fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
                ["<down>"] = "move_cursor_down",
                ["<C-n>"] = "move_cursor_down",
                ["<up>"] = "move_cursor_up",
                ["<C-p>"] = "move_cursor_up",
                ["<esc>"] = "close",
                ["<S-CR>"] = "close_keep_filter",
                ["<C-CR>"] = "close_clear_filter",
                ["<C-w>"] = { "<C-S-w>", raw = true },
                {
                  -- normal mode mappings
                  n = {
                    ["j"] = "move_cursor_down",
                    ["k"] = "move_cursor_up",
                    ["<S-CR>"] = "close_keep_filter",
                    ["<C-CR>"] = "close_clear_filter",
                    ["<esc>"] = "close",
                  },
                },
                -- ["<esc>"] = "noop", -- if you want to use normal mode
                -- ["key"] = function(state, scroll_padding) ... end,
              },
            },

            commands = {}, -- Add a custom command or override a global one using the same function name
          },
          buffers = {
            follow_current_file = {
              enabled = true, -- This will find and focus the file in the active buffer every time
              --              -- the current file is changed while the tree is open.
              leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
            },
            group_empty_dirs = true, -- when true, empty folders will be grouped together
            show_unloaded = true,
            window = {
              mappings = {
                ["d"] = "buffer_delete",
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["o"] = {
                  "show_help",
                  nowait = false,
                  config = { title = "Order by", prefix_key = "o" },
                },
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
              },
            },
          },
          git_status = {
            window = {
              position = "float",
              mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["gU"] = "git_undo_last_commit",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
                ["o"] = {
                  "show_help",
                  nowait = false,
                  config = { title = "Order by", prefix_key = "o" },
                },
                ["oc"] = { "order_by_created", nowait = false },
                ["od"] = { "order_by_diagnostics", nowait = false },
                ["om"] = { "order_by_modified", nowait = false },
                ["on"] = { "order_by_name", nowait = false },
                ["os"] = { "order_by_size", nowait = false },
                ["ot"] = { "order_by_type", nowait = false },
              },
            },
          },
        })
      end,
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
}
