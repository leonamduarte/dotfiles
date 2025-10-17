-- ~/.config/nvim/lua/plugins/java.lua
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      { "hrsh7th/cmp-nvim-lsp", optional = true },
    },
    init = function()
      -- (Opcional) Se quiser garantir instalações via Mason:
      -- Use :Mason para confirmar que estes estão instalados:
      --   jdtls, java-debug-adapter, java-test
      -- LazyVim já traz Mason; aqui só observação.
    end,
  },
}
