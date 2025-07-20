-- lua/plugins/telescope.lua

return {
    -- Configuração principal do Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6", -- Recomendo fixar em uma tag estável
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                -- Configurações globais do Telescope aqui
                defaults = {
                    -- Exemplo: Ignorar arquivos em .git
                    file_ignore_patterns = { ".git/" },
                },
                -- Adicione mais configurações globais do Telescope conforme necessário
            })
        end,
    },

    -- Configuração do Telescope File Browser (que depende do Telescope)
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            -- Garante que o Telescope esteja configurado antes de configurar a extensão
            -- Esta parte é importante para o file_browser
            require("telescope").setup({
                extensions = {
                    file_browser = {
                        theme = "ivy", -- Ou o tema de sua preferência
                        hijack_netrw = true, -- Desabilita netrw e usa telescope-file-browser
                        mappings = {
                            ["i"] = {
                                ["<C-u>"] = function(prompt_bufnr)
                                    for i = 1, #vim.fn.getline(prompt_bufnr) do
                                        vim.fn.feedkeys("\\<BS>", "n")
                                    end
                                end,
                            },
                            ["n"] = {
                                -- Mapeamentos de teclas para o modo normal do file_browser
                                -- Exemplo:
                                -- ["<C-f>"] = require("telescope.actions").toggle_selection,
                                -- ["<C-g>"] = require("telescope.actions").move_selection_next,
                            },
                        },
                    },
                },
            })
            -- Carrega a extensão do file_browser
            require("telescope").load_extension("file_browser")
        end,
    },

    -- Adicione outros plugins do Telescope aqui, se tiver
}
