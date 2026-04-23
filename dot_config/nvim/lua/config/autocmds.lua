-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Fechar com 'q' em janelas de utilitários
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("quit_with_q"),
  pattern = { "help", "qf", "lspinfo", "spectre_panel", "man", "git", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Não inserir comentário automaticamente ao quebrar linha
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup("formatoptions"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

-- wrap and spell para text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Equalizar splits ao redimensionar
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  command = "tabdo wincmd =",
})
