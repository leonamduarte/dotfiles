-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Autocmds custom (VeryLazy). Defaults do LazyVim:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Fechar com 'q' em janelas de utilitários
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("quit_with_q"),
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
  group = augroup("formatoptions"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Equalizar splits ao redimensionar a janela do terminal
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  command = "tabdo wincmd =",
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
