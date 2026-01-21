-- ~/.config/nvim/lua/plugins/orgmode.lua
-- Configuração minimalista seguindo Unix Philosophy e "write simple software"
-- Reproduz Doom Emacs +org +dragndrop +journal +pandoc +pretty +roam

return {
  -- Plugin principal: nvim-orgmode
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "nvim-orgmode/org-bullets.nvim", -- +pretty: bullets bonitos
      "chipsenkbeil/org-roam.nvim", -- +roam: zettelkasten
      "nvim-telescope/telescope.nvim", -- busca e navegação
      "nvim-orgmode/telescope-orgmode.nvim", -- integração telescope
    },
    config = function()
      -- Setup básico do orgmode
      require("orgmode").setup({
        org_agenda_files = "~/org/**/*",
        org_default_notes_file = "~/org/refile.org",

        -- Templates de captura (+journal incluso)
        org_capture_templates = {
          -- Template padrão
          t = {
            description = "Task",
            template = "* TODO %?\n  %u",
          },
          -- +journal: Daily journal
          j = {
            description = "Journal",
            template = "* %<%H:%M> %?\n",
            target = "~/org/journal/%<%Y-%m-%d>.org",
          },
          -- Quick note
          n = {
            description = "Note",
            template = "* %?\n  %u",
            target = "~/org/notes.org",
          },
        },

        -- Configurações visuais simples
        org_hide_leading_stars = true,
        org_hide_emphasis_markers = true,

        -- Exportação (+pandoc será via comando externo)
        -- Org já suporta export nativo para HTML, LaTeX, etc
      })

      -- +pretty: org-bullets para visual agradável
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

      -- +roam: org-roam para zettelkasten
      require("org-roam").setup({
        directory = "~/org/roam",
        -- Dailies integrado (+journal funcionalidade)
        extensions = {
          dailies = {
            bindings = {
              goto_today = "<LocalLeader>nd",
              goto_tomorrow = "<LocalLeader>nf",
              goto_yesterday = "<LocalLeader>ny",
            },
            templates = {
              d = {
                description = "daily",
                template = "* %<%H:%M> %?",
                target = "%<%Y-%m-%d>.org",
              },
            },
          },
        },
      })

      -- Telescope integração
      require("telescope").load_extension("orgmode")
    end,
  },

  -- Plugin auxiliar: drag and drop de imagens (+dragndrop)
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    ft = { "org" },
    opts = {
      default = {
        dir_path = "~/org/images",
      },
      filetypes = {
        org = {
          template = "#+ATTR_ORG: :width 500\n[[file:$FILE_PATH]]",
        },
      },
    },
    keys = {
      { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image", ft = "org" },
    },
  },

  -- Keymaps adicionais em orgmode
  {
    "nvim-orgmode/orgmode",
    keys = function()
      return {
        -- Org-roam keys
        { "<leader>nf", "<cmd>lua require('org-roam').node.find()<cr>", desc = "Roam Find Node" },
        { "<leader>ni", "<cmd>lua require('org-roam').node.insert()<cr>", desc = "Roam Insert Node" },
        { "<leader>nc", "<cmd>lua require('org-roam').capture.capture()<cr>", desc = "Roam Capture" },

        -- Telescope orgmode
        { "<leader>or", "<cmd>Telescope orgmode refile_heading<cr>", desc = "Refile Heading" },
        { "<leader>oh", "<cmd>Telescope orgmode search_headings<cr>", desc = "Search Headings" },
        { "<leader>ol", "<cmd>Telescope orgmode insert_link<cr>", desc = "Insert Link" },

        -- Export (+pandoc via comando shell)
        -- Usa pandoc externamente, simples e Unix-way
        { "<leader>ep", ":!pandoc % -o %:r.pdf<CR>", desc = "Export to PDF", ft = "org" },
        { "<leader>eh", ":!pandoc % -o %:r.html<CR>", desc = "Export to HTML", ft = "org" },
        { "<leader>ed", ":!pandoc % -o %:r.docx<CR>", desc = "Export to DOCX", ft = "org" },
      }
    end,
  },
}
