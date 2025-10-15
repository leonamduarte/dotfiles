return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release",
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
            },
        },

        opts = function()
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")
            local fb_actions = require("telescope._extensions.file_browser.actions")

            local common_i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                ["<C-t>"] = actions.select_tab,
                ["<F4>"] = action_layout.toggle_preview,
                ["<C-h>"] = "which_key",
                ["<C-u>"] = false,
            }
            local common_n = {
                ["q"] = actions.close,
                ["s"] = actions.select_horizontal,
                ["v"] = actions.select_vertical,
                ["t"] = actions.select_tab,
                ["<F4>"] = action_layout.toggle_preview,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            }

            return {
                defaults = {
                    sorting_strategy = "ascending",
                    layout_strategy = "flex",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.6 },
                        vertical = { prompt_position = "top", preview_height = 0.45 },
                        height = 0.85,
                        width = 0.80,
                    },
                    border = true,
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    dynamic_preview_title = true,
                    path_display = { "truncate" },
                    file_ignore_patterns = { ".git/" },
                    mappings = { i = common_i, n = common_n },
                },

                pickers = {
                    find_files = { hidden = true, follow = true },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                    oldfiles = { only_cwd = false },
                    buffers = { sort_mru = true, ignore_current_buffer = true },
                    diagnostics = { bufnr = 0 }, -- buffer diagnostics por padrão
                },

                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    file_browser = {
                        path = vim.loop.cwd(),
                        cwd = vim.loop.cwd(),
                        grouped = false,
                        files = true,
                        add_dirs = true,
                        depth = 1,
                        hidden = { file_browser = false, folder_browser = false },
                        respect_gitignore = vim.fn.executable("fd") == 1,
                        no_ignore = false,
                        follow_symlinks = false,
                        display_stat = { date = true, size = true, mode = true },
                        hijack_netrw = false,
                        git_status = true,
                        mappings = {
                            ["i"] = {
                                ["<A-c>"] = fb_actions.create,
                                ["<S-CR>"] = fb_actions.create_from_prompt,
                                ["<A-r>"] = fb_actions.rename,
                                ["<A-m>"] = fb_actions.move,
                                ["<A-y>"] = fb_actions.copy,
                                ["<A-d>"] = fb_actions.remove,
                                ["<C-o>"] = fb_actions.open,
                                ["<C-g>"] = fb_actions.goto_parent_dir,
                                ["<C-e>"] = fb_actions.goto_home_dir,
                                ["<C-w>"] = fb_actions.goto_cwd,
                                ["<C-t>"] = fb_actions.change_cwd,
                                ["<C-f>"] = fb_actions.toggle_browser,
                                ["<C-h>"] = fb_actions.toggle_hidden,
                                ["<C-s>"] = fb_actions.toggle_all,
                                ["<bs>"] = fb_actions.backspace,
                            },
                            ["n"] = {
                                ["c"] = fb_actions.create,
                                ["r"] = fb_actions.rename,
                                ["m"] = fb_actions.move,
                                ["y"] = fb_actions.copy,
                                ["d"] = fb_actions.remove,
                                ["o"] = fb_actions.open,
                                ["g"] = fb_actions.goto_parent_dir,
                                ["e"] = fb_actions.goto_home_dir,
                                ["w"] = fb_actions.goto_cwd,
                                ["t"] = fb_actions.change_cwd,
                                ["f"] = fb_actions.toggle_browser,
                                ["h"] = fb_actions.toggle_hidden,
                                ["s"] = fb_actions.toggle_all,
                            },
                        },
                    },
                },
            }
        end,

        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "file_browser")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (project)" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep in project" })
            vim.keymap.set("n", "<leader>fc", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "Find in Neovim config" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
            vim.keymap.set("n", "<leader>fb", builtin.builtin, { desc = "Find Builtin pickers" })
            vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep cword" })
            vim.keymap.set("n", "<leader>fW", function()
                builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
            end, { desc = "Grep cWORD" })
            vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics (buffer)" })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find in buffer" })

            vim.keymap.set("n", "<leader>fe", function()
                telescope.extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
            end, { desc = "File Browser (cwd)" })
            vim.keymap.set("n", "<leader>fE", function()
                telescope.extensions.file_browser.file_browser({ path = vim.fn.stdpath("config") })
            end, { desc = "File Browser (nvim config)" })
        end,
    },
}
