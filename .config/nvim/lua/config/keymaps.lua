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
keymap.set(
    "n",
    "<leader>tE",
    "<cmd>Neotree source=filesystem position=right toggle<cr>",
    { desc = "[T]oggle N[E]otree" }
)

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

-- Map <leader>fp to open projects
keymap.set("n", "<leader>fp", ":ProjectFzf<CR>", { noremap = true, silent = true })

-- Split windows
keymap.set("n", "sh", ":vsplit<Return>", opts)
keymap.set("n", "sv", ":split<Return>", opts)

-- Better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)
-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
