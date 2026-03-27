-- Configure conform.nvim for formatting
-- Use biome for JS/TS/etc and prettier for markdown
local conform = require("conform")

-- Set up formatters by filetype
conform.setup({
  formatters_by_ft = {
    javascript = { "biome" },
    typescript = { "biome" },
    javascriptreact = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    css = { "biome" },
    scss = { "biome" },
    markdown = { "biome" },
    -- Use a fallback formatter for other filetypes
    ["_"] = { "trim_whitespace" },
  },
  -- Set up format-on-save
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
