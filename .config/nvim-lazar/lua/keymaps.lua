local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil Float Mode" })
keymap.set("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Open [L]azy [S]ync" })
keymap.set("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Open [L]azy [U]pdate" })
keymap.set("n", "<leader>li", "<cmd>Lazy install<CR>", { desc = "Open Lazy" })
keymap.set("n", "<leader>h", "<cmd>noh<CR>", { desc = "Unselect search" })
keymap.set("n", "<leader>l", "", { desc = "[L]eo keymaps" })
keymap.set("n", "<leader>ld", "", { desc = "[L]eo [D]irectory" })
keymap.set("n", "<leader>te", "<cmd>Neotree toggle<cr>", { desc = "[T]oggle N[E]otree" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in Float" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format current file" })

-- vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Open recent files" })

-- Navegar entre janelas com Ctrl + h/j/k/l
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Mover para janela da esquerda" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Mover para janela da direita" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Mover para janela abaixo" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Mover para janela acima" })

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Split windows
keymap.set("n", "sh", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "<leader><tab>d", ":tabclose<Return>", opts)

-- LSP Rename
vim.keymap.set("n", "<leader>cr", function()
	vim.lsp.buf.rename()
end, { expr = true, desc = "LSP Rename" })

-- Buffer functions
local function delete_other_buffers()
	local current_buf = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()

	for _, buf in ipairs(buffers) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end

-- Buffers
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })
keymap.set("n", "<leader>bo", delete_other_buffers, { desc = "Delete Other Buffers" })
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)
-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)
