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

-- Placeholder para keymaps específicos meus.
keymap.set("n", "<leader>l", "", { desc = "[L]eo keymaps" })
keymap.set("n", "<leader>ld", "", { desc = "[L]eo [D]irectory" })

-- Alterna a exibição da barra lateral do Neotree.
keymap.set("n", "<leader>te", "<cmd>Neotree toggle<cr>", { desc = "[T]oggle N[E]otree" })

-- Revela o arquivo atual na árvore do Neotree.
keymap.set(
    "n",
    "<leader>e",
    "<Cmd>Neotree position=right dir=%:p:h:h reveal_file=%:p<CR>",
    { desc = "Reveal current file in Neotree(Force CWD)" }
)

-- Alterna (ou abre) o Neotree para o caminho '/run/media/lm/dev'.
keymap.set(
    "n",
    "<leader>ldd",
    "<Cmd>Neotree dir=/run/media/lm/dev<CR>",
    { desc = "Toggle Neotree [L]eo [D]irectory [D]ev" }
)

-- Alterna (ou abre) o Neotree para o caminho '/run/media/lm/dev/maisPraTi/'.
keymap.set(
    "n",
    "<leader>ldm",
    "<Cmd>Neotree dir=/run/media/lm/dev/maisPraTi/<CR>",
    { desc = "Toggle Neotree [L]eo [D]irectory [M]aisPraTi" }
)

-- Força a revelação do diretório de trabalho atual (cwd) no Neotree.
keymap.set("n", "\\", "<Cmd>Neotree reveal<CR>", { desc = "Neotree reveal current file " })

-- Abre a visualização do Neotree mostrando os buffers abertos.
keymap.set("n", "<leader>tb", "<Cmd>Neotree buffers<CR>", { desc = "Open Neotree view of current open buffers" })

-- Mapeamento para abrir o navegador de arquivos do Telescope.
keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { desc = "Open Telescope File Browser" })

-- Abre o navegador de arquivos do Telescope no diretório do buffer atual.
keymap.set(
    "n",
    "<space>fB",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { desc = "Open Telescope File Browser at current buffer's path" }
)

-- Lazy.nvim
keymap.set("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Open [L]azy [S]ync" })
keymap.set("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Open [L]azy [U]pdate" })
keymap.set("n", "<leader>li", "<cmd>Lazy install<CR>", { desc = "Open Lazy" })

-- Abre a informação de diagnóstico (erros/warnings LSP) em uma janela flutuante.
vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
end, { desc = "Open Diagnostic in Float" })

-- Formata o arquivo atual usando o plugin 'conform.nvim'.
vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format current file" })

-- Abrir arquivos recentes via Telescope.
-- vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Open recent files" })

-- Limpa os realces de busca ao pressionar <Esc> no modo normal.
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Mapeia <leader>fp para abrir projetos usando ProjectFzf.
keymap.set("n", "<leader>fp", ":ProjectFzf<CR>", { noremap = true, silent = true, desc = "Open Projects with FZF" })

-- Navegar entre janelas (splits) usando Ctrl + h/j/k/l.
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })

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

-- Redimensionamento de Janelas com Ctrl + ArrowKeys:
-- Reduz a largura da janela ativa em 2 colunas/linhas.
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Shrink window width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Shrink window height" })

-- Ao colar no modo visual, não copia a seleção para o registro padrão.
-- Isso permite colar várias vezes o mesmo conteúdo.
keymap.set("v", "p", '"_dP', opts)

-- Deleta um único caractere sem copiá-lo para o registro (não polui o buffer de cola).
keymap.set("n", "x", '"_x', opts)

vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
