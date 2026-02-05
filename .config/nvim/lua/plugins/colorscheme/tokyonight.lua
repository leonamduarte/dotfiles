return {
  "folke/tokyonight.nvim",
  enabled = false, -- desabilitado por padrão, você já usa cyberdream
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon", -- moon, storm, night, day
      light_style = "day",
      transparent = true,
      terminal_colors = true,

      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },

      dim_inactive = false,
      lualine_bold = false,
      cache = true, -- performance boost

      -- Plugin auto-detection (funciona bem com LazyVim)
      plugins = {
        auto = true,
      },
    })

    -- vim.cmd("colorscheme tokyonight")
  end,
}
