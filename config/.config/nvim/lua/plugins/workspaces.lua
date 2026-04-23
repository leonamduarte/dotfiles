return {
  {
    "natecraddock/workspaces.nvim",
    event = "VeryLazy",
    opts = {
      cd_type = "global",
      sort = true,
      mru_sort = true,
      auto_open = false,
      auto_dir = false,
      notify_info = true,
      hooks = {
        open = {
          function(name, path)
            -- Just cd to the workspace path, let workspaces handle the rest
            vim.cmd("cd " .. vim.fn.fnameescape(path))
          end,
        },
      },
    },
    config = function(_, opts)
      require("workspaces").setup(opts)
      local telescope_ok, telescope = pcall(require, "telescope")
      if telescope_ok then
        telescope.load_extension("workspaces")
      end
    end,
    keys = {
      { "<leader>ws", "<cmd>Telescope workspaces<cr>", desc = "Telescope workspaces" },
    },
  },
}
