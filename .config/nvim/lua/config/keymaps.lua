-- Keymaps são carregados no evento VeryLazy
-- Defaults do LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LuaLS: declare a global Snacks para evitar warning de undefined-global
---@class Snacks
---@field picker table
---@field explorer fun()
---@field layout table
Snacks = Snacks

-- ===== Arquivos / Gerenciadores =====
-- Oil (diretório pai em float)
map("n", "-", "<cmd>Oil --float<CR>", { desc = "Oil: Parent (float)" })

-- Força a revelação do diretório de trabalho atual (cwd) no Neotree.
map("n", "\\", "<Cmd>Neotree reveal<CR>", { desc = "Neotree reveal current file " })

-- ===== Diagnóstico =====
map("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Diagnostics (float)" })

-- ===== Splits =====
-- 'sh' → vertical split (vsplit) | 'sv' → horizontal split (split)
map("n", "sh", ":vsplit<CR>", opts)
map("n", "sv", ":split<CR>", opts)

-- ===== Indentação visual =====
map("v", "<", "<gv", { desc = "Indent -" })
map("v", ">", ">gv", { desc = "Indent +" })

-- ===== Paste/Del “limpos” =====
map("v", "p", '"_dP', opts) -- cola sem sobrescrever registro
map("n", "p", '"_dP', opts) -- cola sem sobrescrever registro
map("n", "x", '"_x', opts) -- deleta char sem ir p/ registro

-- ===== Salvar / Sair =====
map({ "n", "i" }, "<C-s>", function()
  vim.cmd("write")
end, { desc = "Salvar arquivo" })
map("n", "<leader>qq", ":qa<CR>", { desc = "Sair do Neovim" })

-- ===== Navegação de janelas =====
map("n", "<C-h>", "<C-w>h", { desc = "Janela esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela baixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela cima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela direita" })

-- ===== Mover linhas =====
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Mover linha ↓" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Mover linha ↑" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover seleção ↓" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover seleção ↑" })

-- ===== Trouble (diagnósticos) =====
-- LazyVim já integra bem; este toggle é útil:
map("n", "<leader>xx", function()
  require("trouble").toggle()
end, { desc = "Trouble" })

-- Mapeamento para compilar o Java
vim.api.nvim_set_keymap("n", "<leader>jc", ":!javac %<CR>", { noremap = true, silent = true })

-- Mapeamento para rodar o Java
vim.api.nvim_set_keymap("n", "<leader>jr", ":!java %:r<CR>", { noremap = true, silent = true })
