return {
  "mason-org/mason-lspconfig.nvim",
  opts = {},
  dependencies = {
    { "mason-org/mason.nvim", opts = {
      automatic_enable = true,
    } },
    "neovim/nvim-lspconfig",
  },
}
