-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    ---@module "neo-tree"
    ---@type neotree.Config?
    keys = {
        { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
        {
            "<leader>ldd",
            ":Neotree /run/media/lm/dev<CR>",
            desc = "Toogle Neotree [L]eo [D]irectory [D]ev",
            silent = true,
        },
        {
            "<leader>ldm",
            ":Neotree /run/media/lm/dev/maisPraTi/<CR>",
            desc = "Toogle Neotree [L]eo [D]irectory [M]aisPraTi",
            silent = true,
        },
    },
    opts = {
        filesystem = {
            window = {
                mappings = {
                    ["\\"] = "close_window",
                },
            },
        },
    },
}
