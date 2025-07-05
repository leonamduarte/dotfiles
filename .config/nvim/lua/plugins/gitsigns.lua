-- ~/.config/nvim/lua/plugins/gitsigns.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- Configurações válidas:
      update_debounce = 500,
      max_file_length = 10000,

      -- Configuração especial para forçar o caminho do Git:
      _git_bin = "/usr/bin/git", -- Nome correto do parâmetro

      -- Desabilita recursos problemáticos:
      sign_priority = 6,
      attach_to_untracked = false,
      current_line_blame = false,
    },
    init = function()
      -- Garante o PATH corretamente
      vim.env.PATH = "/usr/bin:" .. vim.env.PATH
    end,
  },
}
