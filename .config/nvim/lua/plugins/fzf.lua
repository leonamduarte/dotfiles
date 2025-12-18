return {
  {
    enabled = true,
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- 🎨 Janela / UI
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.30,
        col = 0.50,
        border = "rounded",
        preview = {
          default = "bat",
        },
      },

      -- 🔍 Comportamento do fzf
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline",
      },

      -- 📁 Arquivos
      files = {
        cwd_prompt = false,
        git_icons = true,
        file_icons = true,
        fd_opts = "--hidden --no-ignore",
      },

      -- 🔎 Grep (funciona igual em Linux e Windows)
      grep = {
        rg_opts = "--hidden --glob '!.git/*'",
      },

      -- 🕘 Histórico
      oldfiles = {
        include_current_session = true,
      },

      -- 🧠 Integração com vim.ui.select (LSP, menus, etc.)
      ui_select = true,
    },

    keys = {
      -- 🔍 Busca básica
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },

      -- ⚙️ Config do Neovim (substitui SPC f c do Telescope)
      {
        "<leader>fc",
        function()
          require("fzf-lua").files({
            cwd = vim.fn.stdpath("config"),
          })
        end,
        desc = "Neovim Config",
      },

      -- 🧠 LSP
      { "<leader>ld", "<cmd>FzfLua lsp_definitions<cr>", desc = "LSP Definitions" },
      { "<leader>lr", "<cmd>FzfLua lsp_references<cr>", desc = "LSP References" },
      { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lw", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

      -- 🌿 Git
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
      { "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Buffer Commits" },
      { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },

      -- 📂 Extras úteis
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    },
  },
}
