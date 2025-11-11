return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  dependencies = {
    "nvim-orgmode/org-bullets.nvim",
    "lukas-reineke/headlines.nvim",
    "Saghen/blink.cmp",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("orgmode").setup({
      org_agenda_files = "~/orgfiles/**/*",
      org_default_notes_file = "~/orgfiles/refile.org",
    })
    require("org-bullets").setup({
      symbols = {
        list = "•",
        headlines = { "◉", "○", "✸", "✿" },
        checkboxes = {
          half = { "", "@org.checkbox.halfchecked" },
          done = { "✓", "@org.keyword.done" },
          todo = { " ", "@org.keyword.todo" },
        },
      },
    })
    require("headlines").setup()
    require("blink.cmp").setup({
      sources = {
        per_filetype = {
          org = { "orgmode" },
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
        },
      },
    })
  end,
}
