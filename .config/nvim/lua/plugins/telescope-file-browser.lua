return {
    -- Configuração principal do Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6", -- É uma boa prática fixar em uma tag estável
        dependencies = { "nvim-lua/plenary.nvim" },
        -- Use 'opts' para opções passadas diretamente ao setup do Telescope,
        -- ou 'config' para executar um bloco de código Lua.
        -- Neste caso, como a configuração do file_browser é uma extensão,
        -- faremos a configuração principal do Telescope no bloco do file_browser.
    },

    -- Configuração do Telescope File Browser (que depende do Telescope)
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim", -- Dependência explícita
            "nvim-lua/plenary.nvim", -- Dependência explícita
        },
        -- Use 'config' para executar o setup e carregar a extensão
        config = function()
            -- Carrega as ações do file_browser. Você pode fazer isso aqui ou dentro da tabela de mapeamentos.
            local fb_actions = require("telescope._extensions.file_browser.actions")

            -- Configuração do Telescope (principal) e da extensão file_browser
            -- Esta chamada ao setup do Telescope é crucial e deve incluir todas as extensões.
            require("telescope").setup({
                -- Opções globais do Telescope (se houver)
                defaults = {
                    -- Exemplo: Ignorar arquivos em .git
                    file_ignore_patterns = { ".git/" },
                },
                extensions = {
                    file_browser = {
                        -- Suas opções para o file_browser (algumas duplicadas, mas mantidas para exemplo)
                        path = vim.loop.cwd(),
                        cwd = vim.loop.cwd(),
                        cwd_to_path = false,
                        grouped = false,
                        files = true,
                        add_dirs = true,
                        depth = 1,
                        auto_depth = false,
                        select_buffer = false,
                        hidden = { file_browser = false, folder_browser = false },
                        respect_gitignore = vim.fn.executable("fd") == 1,
                        no_ignore = false,
                        follow_symlinks = false,
                        browse_files = require("telescope._extensions.file_browser.finders").browse_files,
                        browse_folders = require("telescope._extensions.file_browser.finders").browse_folders,
                        hide_parent_dir = false,
                        collapse_dirs = false,
                        prompt_path = false,
                        quiet = false,
                        dir_icon = "",
                        dir_icon_hl = "Default",
                        display_stat = { date = true, size = true, mode = true },
                        hijack_netrw = false,
                        use_fd = true,
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
            })

            -- Carrega a extensão do file_browser após a configuração
            require("telescope").load_extension("file_browser")
        end,
    },
}
