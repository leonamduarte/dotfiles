---@type LazySpec
return {
  "syntaxpresso/bufstate.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    filter_by_tab = false,  -- desabilitado para performance
    autoload_last_session = false,
    stop_lsp_on_tab_leave = false,
    stop_lsp_on_session_load = false,
    autosave = {
      enabled = true,
      on_exit = true,
      interval = 600000,
      debounce = 60000,
    },
  },
  keys = {},
}

