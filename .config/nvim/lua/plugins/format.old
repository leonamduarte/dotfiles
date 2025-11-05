-- =============================
-- lua/plugins/format.lua
-- (ajustes extras para prettier/biome e eslint coexistirem bem)
-- =============================
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Use o que o extra escolher; garantimos ordem quando coexistirem
      opts.formatters_by_ft.javascript = { "biome", "prettier" }
      opts.formatters_by_ft.typescript = { "biome", "prettier" }
      opts.formatters_by_ft.javascriptreact = { "biome", "prettier" }
      opts.formatters_by_ft.typescriptreact = { "biome", "prettier" }
      return opts
    end,
  },
  {
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
                preselect = true,
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
  },
}
