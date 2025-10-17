-- lua/plugins/fzf-lua.lua
return {
    {
        "ibhagwan/fzf-lua",
        -- use o fzf do sistema; se quiser o binário do repo, adicione "junegunn/fzf"
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "FzfLua" },
        opts = function()
            local fzf = require("fzf-lua")

            -- Estilo de janela + preview
            fzf.setup({
                winopts = {
                    height = 0.90,
                    width = 0.90,
                    row = 0.5,
                    col = 0.5,
                    border = "rounded",
                    preview = {
                        default = "bat", -- usa bat se tiver instalado
                        layout = "vertical",
                        vertical = "down:60%",
                    },
                },
                fzf_opts = {
                    -- navegação no menu do fzf
                    ["--info"] = "inline",
                    ["--layout"] = "reverse",
                    ["--marker"] = "+",
                },
                keymap = {
                    builtin = {
                        -- naveg. lista
                        ["<C-j>"] = "down",
                        ["<C-k>"] = "up",
                        ["<C-n>"] = "down",
                        ["<C-p>"] = "up",
                        -- abrir em split/tab
                        ["<C-s>"] = "split",
                        ["<C-v>"] = "vsplit",
                        ["<C-t>"] = "tabedit",
                        -- toggle preview
                        ["<F4>"] = "toggle-preview",
                        -- qflist
                        ["<C-q>"] = "toggle-all+accept-non-empty",
                    },
                },
                files = {
                    prompt = "Files❯ ",
                    git_icons = true,
                    file_icons = true,
                    color_icons = true,
                    -- usa ripgrep para respeitar .gitignore
                    fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
                },
                grep = {
                    prompt = "RipGrep❯ ",
                    rg_opts = [[--hidden --column --line-number --no-heading --color=always --smart-case]],
                },
                buffers = {
                    prompt = "Buffers❯ ",
                    sort_lastused = true,
                    cwd_only = false,
                    actions = {
                        ["ctrl-d"] = { actions = fzf.actions.buf_del, reload = true },
                    },
                },
                diagnostics = {
                    prompt = "Diagnostics❯ ",
                },
                oldfiles = { prompt = "Recent❯ " },
                helptags = { prompt = "Help❯ " },
                keymaps = { prompt = "Keymaps❯ " },
                blines = { prompt = "Buffer Lines❯ " },
            })

            -- ====== Keymaps: equivalentes ao que você tinha no Telescope ======
            local map = vim.keymap.set
            local desc = function(d)
                return { desc = d, silent = true }
            end

            -- Projeto/arquivos
            map("n", "<leader>ff", function()
                fzf.files()
            end, desc("Find files (project)"))
            map("n", "<leader>fg", function()
                fzf.live_grep()
            end, desc("Grep in project"))
            map("n", "<leader>fr", function()
                fzf.oldfiles()
            end, desc("Recent files"))

            -- Ajuda & keymaps & builtins
            map("n", "<leader>fh", function()
                fzf.helptags()
            end, desc("Find Help"))
            map("n", "<leader>fk", function()
                fzf.keymaps()
            end, desc("Find Keymaps"))
            map("n", "<leader>fb", function()
                fzf.builtin()
            end, desc("Find Builtin pickers"))

            -- grep pela palavra sob o cursor (word vs WORD)
            map("n", "<leader>fw", function()
                fzf.grep_cword()
            end, desc("Grep cword"))
            map("n", "<leader>fW", function()
                fzf.grep_cWORD()
            end, desc("Grep cWORD"))

            -- diagnostics do buffer atual
            map("n", "<leader>fd", function()
                fzf.diagnostics_document()
            end, desc("Find diagnostics (buffer)"))

            -- buffers
            map("n", "<leader><leader>", function()
                fzf.buffers()
            end, desc("Buffers"))

            -- fuzzy no buffer atual
            map("n", "<leader>/", function()
                fzf.blines()
            end, desc("Fuzzy find in buffer"))

            -- “File browser” estilo: usa o picker de files com cwd customizado
            map("n", "<leader>fe", function()
                fzf.files({ cwd = vim.fn.expand("%:p:h") })
            end, desc("Files (cwd do buffer)"))
            map("n", "<leader>fE", function()
                fzf.files({ cwd = vim.fn.stdpath("config") })
            end, desc("Files (nvim config)"))

            -- Retorna tabela final (Lazy usa se precisar)
            return {}
        end,
    },
}
