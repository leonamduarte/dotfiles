return {
  {
    "bashln/Doom-One.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      colors = {},
      highlights = {},
    },
    config = function(_, opts)
      require("doom-one").setup(opts)
      vim.cmd.colorscheme("doom-one")
    end,
  },
}
