return {
  "rebelot/kanagawa.nvim",
  enabled = true,
  priority = 1000,
  config = function()
    vim.o.background = "dark"

    require("kanagawa").setup({
      compile = true,
      undercurl = true,
      transparent = false,
      dimInactive = true,
      terminalColors = true,
      theme = "wave",

      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      functionStyle = {},
      typeStyle = {},

      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    })
  end,
}
