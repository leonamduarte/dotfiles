require("config.lazy")
require("lazy").setup({
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
})

vim.notify = function(msg, level, opts)
    if msg:match("textDocument/codeAction") then
        return
    end
    vim.schedule(function()
        vim.api.nvim_echo({ { msg } }, true, {})
    end)
end
