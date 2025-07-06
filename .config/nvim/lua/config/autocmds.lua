vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "pt_br" -- ou "en,pt_br" para múltiplos idiomas
  end,
})
