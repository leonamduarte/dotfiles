-- ~/.config/nvim/lua/plugins/orgmode.lua
return {
  -- Plugin principal: nvim-orgmode
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "nvim-orgmode/org-bullets.nvim", -- Visual
      "chipsenkbeil/org-roam.nvim", -- Zettelkasten
    },
    config = function()
      -- Setup básico do orgmode
      require("orgmode").setup({
        org_agenda_files = "~/org/**/*",
        org_default_notes_file = "~/org/refile.org",

        -- Templates de captura
        org_capture_templates = {
          t = { description = "Task", template = "* TODO %?\n  %u" },
          j = { description = "Journal", template = "* %<%H:%M> %?\n", target = "~/org/journal/%<%Y-%m-%d>.org" },
          n = { description = "Note", template = "* %?\n  %u", target = "~/org/notes.org" },
        },

        -- Configurações visuais
        org_hide_leading_stars = true,
        org_hide_emphasis_markers = true,
      })

      -- Visual: Bullets
      require("org-bullets").setup({
        symbols = {
          headlines = { "◉", "○", "✸", "✿" },
          checkboxes = {
            half = { "▭", "@org.checkbox.halfchecked" },
            done = { "✓", "@org.keyword.done" },
            todo = { "˟", "@org.keyword.todo" },
          },
        },
      })

      -- Roam: Zettelkasten
      require("org-roam").setup({
        directory = "~/org/roam",
        extensions = {
          dailies = {
            bindings = {
              goto_today = "<LocalLeader>nd",
              goto_tomorrow = "<LocalLeader>nf",
              goto_yesterday = "<LocalLeader>ny",
            },
            templates = {
              d = { description = "daily", template = "* %<%H:%M> %?", target = "%<%Y-%m-%d>.org" },
            },
          },
        },
      })
      -- Removido: require("telescope").load_extension("orgmode")
    end,
  },

  -- Plugin auxiliar: Drag & Drop de imagens
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    ft = { "org" },
    opts = {
      default = { dir_path = "~/org/images" },
      filetypes = {
        org = { template = "#+ATTR_ORG: :width 500\n[[file:$FILE_PATH]]" },
      },
    },
    keys = {
      { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image", ft = "org" },
    },
  },

  -- Keymaps: Substituindo Telescope por FzfLua + Native Lua
  {
    "nvim-orgmode/orgmode",
    keys = function()
      return {
        -- --- Org-Roam ---
        -- Como o org-roam usa internamente lógica de seleção, podemos usar FzfLua
        -- para encontrar os arquivos físicos diretamente.
        {
          "<leader>nf",
          function()
            require("fzf-lua").files({ cwd = "~/org/roam", prompt = "Roam Nodes> " })
          end,
          desc = "Find Roam Node (Files)",
        },
        { "<leader>ni", "<cmd>lua require('org-roam').node.insert()<cr>", desc = "Roam Insert Node" },
        { "<leader>nc", "<cmd>lua require('org-roam').capture.capture()<cr>", desc = "Roam Capture" },

        -- --- Orgmode Navigation (FzfLua) ---
        -- Busca textual em todos os arquivos org (substitui search_headings)
        {
          "<leader>oh",
          function()
            require("fzf-lua").live_grep({ cwd = "~/org", glob = "*.org", prompt = "Org Grep> " })
          end,
          desc = "Search Org Files (Grep)",
        },
        -- Busca arquivos org gerais
        {
          "<leader>of",
          function()
            require("fzf-lua").files({ cwd = "~/org", prompt = "Org Files> " })
          end,
          desc = "Find Org Files",
        },

        -- --- Ações Nativas do Orgmode ---
        -- O orgmode moderno usa vim.ui.select, então o FzfLua deve capturar isso automaticamente
        -- se o LazyVim estiver com 'stevearc/dressing.nvim' ou 'fzf-lua' configurado como ui.select default.
        { "<leader>or", "<cmd>OrgRefile<cr>", desc = "Refile Heading" },
        { "<leader>ol", "<cmd>OrgInsertLink<cr>", desc = "Insert Link" },

        -- --- Export (Pandoc) ---
        { "<leader>ep", ":!pandoc % -o %:r.pdf<CR>", desc = "Export to PDF", ft = "org" },
        { "<leader>eh", ":!pandoc % -o %:r.html<CR>", desc = "Export to HTML", ft = "org" },
        { "<leader>ed", ":!pandoc % -o %:r.docx<CR>", desc = "Export to DOCX", ft = "org" },
      }
    end,
  },
}
