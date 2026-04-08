-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Líder (LazyVim já tem, mas mantemos por costume)
vim.g.mapleader = " "

-- ===== Performance =====
opt.ttimeoutlen = 50       -- timeout mais curto para keycodes

-- ===== Configurações personalizadas (diferentes do LazyVim) =====
opt.showtabline = 2  -- mostrar abas no topo
opt.wrap = false     -- não quebrar linha
opt.hlsearch = false -- não highlight search automático

-- Mostrar caracteres invisíveis
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ===== LazyVim specifics =====
-- ESLint autoformat (se estiver usando extras linting.eslint)
vim.g.lazyvim_eslint_auto_format = true