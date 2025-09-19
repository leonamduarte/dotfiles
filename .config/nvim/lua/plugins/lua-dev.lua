-- =============================
-- lua/plugins/lua-dev.lua
-- (DX para Lua: lazydev + fonte em blink)
-- =============================

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "LazyVim",
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
