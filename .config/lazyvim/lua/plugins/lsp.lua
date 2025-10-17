return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        -- Attach: keymaps, highlights, inlay hints
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("fzf-lua").lsp_definitions, "Goto Definition")
                map("gr", require("fzf-lua").lsp_references, "Goto References")
                map("gI", require("fzf-lua").lsp_implementations, "Goto Implementation")
                map("<leader>D", require("fzf-lua").lsp_typedefs, "Type Definition")
                map("<leader>ds", require("fzf-lua").lsp_document_symbols, "Document Symbols")
                map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "Workspace Symbols")
                map("<leader>cr", vim.lsp.buf.rename, "Rename")
                map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
                map("gD", vim.lsp.buf.declaration, "Goto Declaration")

                local function supports(client, method, bufnr)
                    if vim.fn.has("nvim-0.11") == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local aug = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = aug,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = aug,
                        callback = vim.lsp.buf.clear_references,
                    })
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(ev)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev.buf })
                        end,
                    })
                end

                if client and supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "Toggle Inlay Hints")
                end
            end,
        })

        -- Diagnostics
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(d)
                    return d.message
                end,
            },
        })

        -- Capabilities (blink.cmp)
        local base_caps = vim.lsp.protocol.make_client_capabilities()
        local capabilities = require("blink.cmp").get_lsp_capabilities(base_caps)

        -- Servers
        local servers = {
            bashls = {},
            marksman = {},

            -- Lua
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        diagnostics = { globals = { "vim" } },
                        completion = { callSnippet = "Replace" },
                    },
                },
            },

            -- Tailwind (com Phoenix/Elixir)
            tailwindcss = {
                filetypes_exclude = { "markdown" },
                filetypes_include = {},
                settings = {
                    tailwindCSS = {
                        includeLanguages = { elixir = "html-eex", eelixir = "html-eex", heex = "html-eex" },
                    },
                },
            },

            -- JavaScript / TypeScript (VTSLS = melhor performance & recursos)
            vtsls = {
                settings = {
                    typescript = {
                        inlayHints = {
                            enumMemberValues = { enabled = true },
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = "literals" },
                            parameterTypes = { enabled = true },
                            propertyDeclarationTypes = { enabled = true },
                            variableTypes = { enabled = true },
                        },
                        format = { enable = false },
                        preferences = { includePackageJsonAutoImports = "on" },
                    },
                    javascript = {
                        inlayHints = {
                            enumMemberValues = { enabled = true },
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = "literals" },
                            parameterTypes = { enabled = true },
                            propertyDeclarationTypes = { enabled = true },
                            variableTypes = { enabled = true },
                        },
                        format = { enable = false },
                    },
                    vtsls = {
                        autoUseWorkspaceTsdk = true,
                        enableMoveToFileCodeAction = true,
                    },
                },
                -- Deixe o format para Prettier/Prettierd
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            },

            -- ESLint para Code Actions e diagnósticos
            eslint = {
                settings = {
                    workingDirectory = { mode = "auto" },
                    codeAction = { disableRuleComment = { enable = true }, showDocumentation = { enable = true } },
                },
            },

            -- Vue (Volar)
            volar = {
                filetypes = { "vue" },
                init_options = {
                    vue = { hybridMode = true }, -- SFC + TS juntos
                },
            },

            -- Emmet (JSX/TSX/Vue/HTML/CSS)
            emmet_ls = {
                filetypes = {
                    "html",
                    "css",
                    "scss",
                    "less",
                    "sass",
                    "javascriptreact",
                    "typescriptreact",
                    "vue",
                    "astro",
                },
            },
        }

        -- Tailwind filetypes merge/exclude/include
        local setup = {
            tailwindcss = function(_, opts)
                local tw = require("lspconfig.server_configurations.tailwindcss")
                opts.filetypes = opts.filetypes or {}
                vim.list_extend(opts.filetypes, tw.default_config.filetypes)
                opts.filetypes = vim.tbl_filter(function(ft)
                    return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
                end, opts.filetypes)
                vim.list_extend(opts.filetypes, opts.filetypes_include or {})
            end,
        }

        -- Mason: instalar tudo que usamos (nomes corretos do Mason)
        local ensure = {
            -- LSP servers (Mason package names)
            "bash-language-server",
            "marksman",
            "lua-language-server",
            "tailwindcss-language-server",
            "vtsls",
            "vue-language-server", -- Volar
            "emmet-language-server",
            "eslint-lsp",
        }

        -- Extra tools
        vim.list_extend(ensure, {
            "astro-language-server",
            "biome",
            "css-lsp",
            "debugpy",
            "delve",
            "docker-compose-language-service",
            "dockerfile-language-server",
            "hadolint",
            "glow",
            "intelephense",
            "js-debug-adapter",
            "markdown_oxide",
            "markdownlint",
            "markdownlint-cli2",
            "markmap-cli",
            "neocmakelsp",
            "php-debug-adapter",
            "phpstan",
            "prettier",
            "prettierd",
            "pyright",
            "ruff",
            "stylua",
        })

        require("mason-tool-installer").setup({
            ensure_installed = ensure,
            -- integrations = {
            --     ["mason-lspconfig"] = true,
            --     ["mason-null-ls"] = true,
            --     ["mason-nvim-dap"] = false, -- desativa a integração DAP para evitar dupla config
            -- },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- aplicar setup específico se existir
                    if server_name == "tailwindcss" and type(setup.tailwindcss) == "function" then
                        setup.tailwindcss(server_name, server)
                    end
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
