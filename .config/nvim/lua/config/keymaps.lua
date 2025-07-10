vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil Float Mode" })
vim.keymap.set("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Open [L]azy [S]ync" })
vim.keymap.set("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Open [L]azy [U]pdate" })
vim.keymap.set("n", "<leader>li", "<cmd>Lazy install<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>h", "<cmd>noh<CR>", { desc = "Unselect search" })
vim.keymap.set("n", "<leader>l", "", { desc = "[l]eo keymaps" })
vim.keymap.set("n", "<leader>ld", "", { desc = "[l]eo [D]irectory" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in Float" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format current file" })

-- vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Open recent files" })

-- Navegar entre janelas com Ctrl + h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Mover para janela da esquerda" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Mover para janela da direita" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Mover para janela abaixo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Mover para janela acima" })
