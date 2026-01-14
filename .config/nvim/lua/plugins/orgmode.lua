return {
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "lukas-reineke/headlines.nvim",
    },
    config = function()
      -- Orgmode core
      require("orgmode").setup({
        org_agenda_files = { "~/org/**/*" },
        org_default_notes_file = "~/org/refile.org",

        org_hide_leading_stars = true,
        org_startup_indented = true,
        org_startup_folded = "content",

        org_log_done = "time",

        org_todo_keywords = {
          "TODO(t)",
          "NEXT(n)",
          "WAIT(w)",
          "|",
          "DONE(d)",
          "CANCELLED(c)",
        },

        org_bullets = {
          heading = {
            "◉",
            "○",
            "✸",
            "✿",
            "◆",
          },
          checkbox = {
            half = "",
            done = "✓",
            todo = "˟",
          },
        },
      })

      -- Folding com Tree-sitter (triângulos tipo Doom)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 99

      -- Headlines (títulos grandes e elegantes)
      require("headlines").setup({
        org = {
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
          },
          bullet_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
          },
          codeblock_highlight = "CodeBlock",
          dash_string = "━",
        },
      })

      -- Keymaps úteis
      vim.keymap.set("n", "<leader>oa", "<cmd>OrgAgenda<CR>", { desc = "Org Agenda" })
      vim.keymap.set("n", "<leader>oc", "<cmd>OrgCapture<CR>", { desc = "Org Capture" })
      vim.keymap.set("n", "<leader>ot", "<cmd>OrgTodo<CR>", { desc = "Org Todo" })
    end,
  },
}
