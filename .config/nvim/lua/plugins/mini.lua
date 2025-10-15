return {
    -- mini.nvim core (ai, surround, move)
    {
        "echasnovski/mini.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("mini.ai").setup({ n_lines = 500 })

            require("mini.surround").setup({
                mappings = {
                    add = "gsa",
                    delete = "gsd",
                    find = "gsf",
                    find_left = "gsF",
                    highlight = "gsh",
                    replace = "gsr",
                    update_n_lines = "gsn",
                },
            })

            require("mini.move").setup({
                mappings = {
                    left = "H",
                    right = "L",
                    down = "J",
                    up = "K",
                    line_left = "",
                    line_right = "",
                    line_down = "",
                    line_up = "",
                },
            })

            -- extras simples
            require("mini.comment").setup()
            require("mini.pairs").setup()
        end,
    },

    -- mini.hipatterns com suporte a Tailwind
    {
        "echasnovski/mini.hipatterns",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = function()
            local hi = require("mini.hipatterns")
            local M = { hl = {} }

            return {
                tailwind = {
                    enabled = true,
                    ft = {
                        "astro",
                        "css",
                        "heex",
                        "html",
                        "html-eex",
                        "javascript",
                        "javascriptreact",
                        "rust",
                        "svelte",
                        "typescript",
                        "typescriptreact",
                        "vue",
                    },
                    style = "full", -- full = palavra toda, compact = só a cor
                },
                highlighters = {
                    hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
                    shorthand = {
                        pattern = "()#%x%x%x()%f[^%x%w]",
                        group = function(_, _, data)
                            local match = data.full_match
                            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                            local hex_color = "#" .. r .. r .. g .. g .. b .. b
                            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
                        end,
                        extmark_opts = { priority = 2000 },
                    },
                },
                config = function(_, opts)
                    if type(opts.tailwind) == "table" and opts.tailwind.enabled then
                        vim.api.nvim_create_autocmd("ColorScheme", {
                            callback = function()
                                M.hl = {}
                            end,
                        })
                        opts.highlighters.tailwind = {
                            pattern = function()
                                if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
                                    return
                                end
                                if opts.tailwind.style == "full" then
                                    return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
                                elseif opts.tailwind.style == "compact" then
                                    return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
                                end
                            end,
                            group = function(_, _, m)
                                local match = m.full_match
                                local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
                                shade = tonumber(shade)
                                local bg = vim.tbl_get(require("mini.hipatterns").config.colors, color, shade)
                                if bg then
                                    local hl = "MiniHipatternsTailwind" .. color .. shade
                                    if not M.hl[hl] then
                                        M.hl[hl] = true
                                        local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
                                        local fg =
                                            vim.tbl_get(require("mini.hipatterns").config.colors, color, bg_shade)
                                        vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
                                    end
                                    return hl
                                end
                            end,
                            extmark_opts = { priority = 2000 },
                        }
                    end
                    require("mini.hipatterns").setup(opts)
                end,
            }
        end,
    },
}
