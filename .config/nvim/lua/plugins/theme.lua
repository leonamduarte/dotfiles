return {
  {
    -- esse módulo não precisa declarar plugin se você só controla tema,
    -- mas o Lazy exige ao menos uma entrada
    "nvim-lua/plenary.nvim", -- pode ser qualquer plugin neutro
    config = function()
      local uname = vim.loop.os_uname()

      if uname.sysname == "Linux" then
        local path = vim.fn.expand("$HOME/.config/omarchy/current/theme/neovim.lua")
        dofile(path)
      else
        vim.cmd("colorscheme cyberdream")
      end
    end,
  },
}
