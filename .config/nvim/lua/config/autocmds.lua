-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Cria um grupo de autocommands para melhor organização
local augroup = vim.api.nvim_create_augroup("LspInlayHints", { clear = true })

-- Adiciona o autocommand no grupo
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
        -- Obtém o cliente LSP
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- Verifica se o servidor de linguagem suporta inlay hints
        if client and client.server_capabilities.inlayHintProvider then
            -- Habilita os inlay hints para o buffer atual
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})
