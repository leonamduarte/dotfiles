-- Autocmds custom (VeryLazy). Defaults do LazyVim:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local aug = vim.api.nvim_create_augroup

-- Fechar com 'q' em janelas de utilitários
vim.api.nvim_create_autocmd("FileType", {
  group = aug("leonam_quit_with_q", { clear = true }),
  pattern = {
    "help",
    "qf",
    "lspinfo",
    "spectre_panel",
    "man",
    "git",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Não inserir comentário automaticamente ao quebrar linha com 'o'/'O'
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = aug("leonam_formatoptions", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

-- Spell & wrap para textos
vim.api.nvim_create_autocmd("FileType", {
  group = aug("leonam_text_ft", { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

-- Equalizar splits ao redimensionar a janela do terminal
vim.api.nvim_create_autocmd("VimResized", {
  group = aug("leonam_resize_splits", { clear = true }),
  command = "tabdo wincmd =",
})
