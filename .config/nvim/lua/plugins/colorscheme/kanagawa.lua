return {
  "rebelot/kanagawa.nvim",
  branch = "master",
  config = function()
    require("kanagawa").setup({
      transparent = false,
    })
    -- vim.cmd("colorscheme kanagawa");
  end,
}
