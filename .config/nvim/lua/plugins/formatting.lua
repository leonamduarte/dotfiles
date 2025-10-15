local supported = {
    "css",
    "graphql",
    "handlebars",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "less",
    "scss",
    "typescript",
    "typescriptreact",
    "vue",
    "yaml",
}

return {
    -- Completion (blink)
    {
        {
            "saghen/blink.compat",
            version = "*",
            lazy = true,
            opts = {},
        },
        {
            "saghen/blink.cmp",
            dependencies = { "rafamadriz/friendly-snippets", "moyiz/blink-emoji.nvim", "ray-x/cmp-sql" },
            version = "1.*",
            opts = {
                keymap = { preset = "default", ["<TAB>"] = { "accept", "fallback" } },
                appearance = { nerd_font_variant = "mono" },
                completion = {
                    documentation = {
                        auto_show = true,
                    },
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                },
                signature = { enabled = true },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
                    providers = {
                        emoji = {
                            module = "blink-emoji",
                            name = "Emoji",
                            score_offset = 15,
                            opts = { insert = true },
                            should_show_items = function()
                                return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
                            end,
                        },
                        sql = {
                            name = "sql",
                            module = "blink.compat.source",
                            score_offset = -3,
                            opts = {},
                            should_show_items = function()
                                return vim.o.filetype == "sql"
                            end,
                        },
                    },
                },
                fuzzy = { implementation = "prefer_rust_with_warning" },
            },
            opts_extend = { "sources.default" },
        },
    },

    -- Formatting (conform)
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                rust = { "rustfmt" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
            },
        },
    },

    -- Mason + Conform integration + none-ls
    {
        {
            "williamboman/mason.nvim",
            opts = { ensure_installed = { "prettier", "prettierd" } },
        },
        {
            "stevearc/conform.nvim",
            optional = true,
            opts = function(_, opts)
                opts.formatters_by_ft = opts.formatters_by_ft or {}
                for _, ft in ipairs(supported) do
                    opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
                    table.insert(opts.formatters_by_ft[ft], "prettierd")
                    table.insert(opts.formatters_by_ft[ft], "prettier")
                end
                opts.format_after_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    local ft = vim.bo[bufnr].filetype
                    if vim.tbl_contains(supported, ft) then
                        return { formatters = { "prettierd", "prettier" }, timeout_ms = 2000 }
                    end
                    return { lsp_format = "fallback" }
                end
            end,
        },
        {
            "nvimtools/none-ls.nvim",
            optional = true,
            opts = function(_, opts)
                local nls = require("null-ls")
                opts.sources = opts.sources or {}
                table.insert(opts.sources, nls.builtins.formatting.prettier)
            end,
        },
    },

    -- Organize imports on save (VTSLS)
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue" },
                callback = function(args)
                    local fname = vim.api.nvim_buf_get_name(args.buf)
                    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = args.buf })) do
                        if client.name == "vtsls" then
                            client.request(
                                "workspace/executeCommand",
                                { command = "_typescript.organizeImports", arguments = { fname } },
                                function() end,
                                args.buf
                            )
                            break
                        end
                    end
                end,
            })
        end,
    },
}
