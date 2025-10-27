-- =============================
-- lua/plugins/extras.lua
-- (ajustes diversos e de SO)
-- =============================
local on_windows = (vim.uv.os_uname().sysname == "Windows_NT")

return {
  -- Ex.: evitar image.nvim no Windows
  {
    "3rd/image.nvim",
    enabled = not on_windows,
    ft = { "markdown", "rmarkdown", "quarto" },
    opts = {},
  },
  -- Trouble para diagnósticos agradáveis
  { "folke/trouble.nvim", opts = {} },
}
