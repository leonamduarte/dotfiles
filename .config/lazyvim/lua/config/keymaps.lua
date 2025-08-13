-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================================================
-- Arquivo de Configuração de Mapeamentos de Teclas (Keymaps) para Neovim
-- ============================================================================

-- Define uma variável local 'keymap' para simplificar o uso de vim.keymap.set.
local keymap = vim.keymap

-- Define opções padrão para os mapeamentos:
--   'noremap = true': Garante que o mapeamento não seja recursivo,
--                     evitando comportamentos inesperados.
--   'silent = true': Evita que o comando seja exibido na linha de comando
--                    ao ser executado.
local opts = { noremap = true, silent = true }

---
--- Navegação de Arquivos e Gerenciadores de Arquivos (Oil & Neotree)
--- Estes mapeamentos facilitam a navegação pelo sistema de arquivos e o uso de gerenciadores de arquivos como Oil e Neotree.
---
-- Abre o diretório pai no modo flutuante do plugin Oil.
keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil Float Mode" })

-- Abre a informação de diagnóstico (erros/warnings LSP) em uma janela flutuante.
vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in Float" })

-- Abrir arquivos recentes via Telescope.
-- vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Open recent files" })

-- Limpa os realces de busca ao pressionar <Esc> no modo normal.
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Mapeia <leader>fp para abrir projetos usando ProjectFzf.
keymap.set("n", "<leader>fp", ":ProjectFzf<CR>", { noremap = true, silent = true, desc = "Open Projects with FZF" })

-- Divisão de janelas:
-- 'sh' para split horizontal (vsplit).
keymap.set("n", "sh", ":vsplit<Return>", opts)
-- 'sv' para split vertical (split).
keymap.set("n", "sv", ":split<Return>", opts)

-- Melhorias na indentação visual:
-- Reduz a indentação da seleção no modo visual.
keymap.set("v", "<", "<gv", { desc = "Decrease indent" })
-- Aumenta a indentação da seleção no modo visual.
keymap.set("v", ">", ">gv", { desc = "Increase indent" })

-- Ao colar no modo visual, não copia a seleção para o registro padrão.
-- Isso permite colar várias vezes o mesmo conteúdo.
vim.keymap.set("v", "p", '"_dP', opts)

-- Deleta um único caractere sem copiá-lo para o registro (não polui o buffer de cola).
vim.keymap.set("n", "x", '"_x', opts)
