-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

-- Líder
g.mapleader = " "

-- ========== UI / Edição ==========
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 10 -- manter “folga” vertical
opt.sidescrolloff = 8

-- Mostrar caracteres invisíveis (útil p/ revisão)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ========== Indentação ==========
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- ========== Busca ==========
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- ========== Desempenho ==========
opt.updatetime = 150
opt.timeoutlen = 400

-- ========== Outros ==========
opt.splitbelow = true
opt.splitright = true
opt.conceallevel = 2

-- ===== ShaDa Configuration (fixes E138 & recent files persistence) =====
-- Configure ShaDa to store recent files, history, marks, etc.
opt.shada = {
  "!'", -- Last cursor position for all files
  "<50", -- Last 50 lines in registers
  "@/", -- Search history
  "b1", -- Marked files (buffers)
  "c100", -- Last 100 copied/deleted strings
  "f1", -- Global marks
  "r50", -- 50 recent files (this fixes SPC f r!)
  "s10", -- 10 last substituted patterns
  "h100", -- 100 items in search history
  "%", -- Buffer list (for sessions)
}

-- Handle ShaDa write errors gracefully
vim.api.nvim_create_autocmd("VimLeavePre", {
  pattern = "*",
  callback = function()
    local ok, err = pcall(function()
      vim.cmd("wshada!")
    end)
    if not ok then
      vim.notify("ShaDa write failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end,
})

-- ===== LazyVim specifics =====
-- ESLint autoformat (se estiver usando extras linting.eslint)
g.lazyvim_eslint_auto_format = true
-- Toggle global de autoformat no save (do LazyVim); deixe comentado se não quiser mexer.
g.autoformat = true

-- Ensure Neovim sees user-installed binaries (prettier/biome) in ~/.local/bin
-- This helps conform locate the executables when running formatters.
if vim.env.HOME then
  local local_bin = vim.fn.expand("~/.local/bin")
  if local_bin and local_bin ~= "" then
    local sep = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and ";" or ":"
    vim.env.PATH = local_bin .. sep .. (vim.env.PATH or "")
  end
end
