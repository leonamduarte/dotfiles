return {
  -- Neorg (somente para .norg)
  {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = true,
    ft = { "norg" },
  },

  -- Orgmode (somente para .org)
  {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    event = "VeryLazy",
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/orgfiles/**/*" },
        org_default_notes_file = "~/orgfiles/refile.org",
      })

      -- NÃO habilita LSP aqui a menos que você tenha um LSP "org" de verdade.
      -- Se você quer highlight/indent/format, treesitter + plugins já resolvem.
    end,
  },

  -- Telescope extension for orgmode
  {
    "nvim-orgmode/telescope-orgmode.nvim",
    ft = { "org" },
    event = "VeryLazy",
    dependencies = {
      "nvim-orgmode/orgmode",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("orgmode")

      local ext = telescope.extensions.orgmode
      vim.keymap.set("n", "<leader>or", ext.refile_heading, { desc = "Org: refile heading" })
      vim.keymap.set("n", "<leader>oh", ext.search_headings, { desc = "Org: search headings" })
      vim.keymap.set("n", "<leader>ol", ext.insert_link, { desc = "Org: insert link" })
      vim.keymap.set("n", "<leader>ot", ext.search_tags, { desc = "Org: search tags" })
    end,
  },

  -- Bullets for org (arrumado)
  {
    "akinsho/org-bullets.nvim",
    ft = { "org" },
    config = function()
      require("org-bullets").setup({
        concealcursor = false,
        symbols = {
          list = "•",
          -- escolha UMA estratégia de headlines (não 4 ao mesmo tempo)
          headlines = {
            { "◉", "MyBulletL1" },
            { "○", "MyBulletL2" },
            { "✸", "MyBulletL3" },
            { "✿", "MyBulletL4" },
          },
          checkboxes = {
            half = { "", "@org.checkbox.halfchecked" },
            done = { "✓", "@org.keyword.done" },
            todo = { "˟", "@org.keyword.todo" },
          },
        },
      })
    end,
  },

  -- Pretty headlines (limite por ft pra não afetar tudo)
  {
    "lukas-reineke/headlines.nvim",
    ft = { "org", "norg", "markdown" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
  },

  -- Org-roam (somente se você realmente usa)
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.2.0",
    ft = { "org" },
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        -- Se você pinna aqui, ideal pinna no plugin principal também (pra evitar drift).
        -- tag = "0.7.0",
      },
    },
    config = function()
      require("org-roam").setup({
        directory = "~/org_roam_files",
        -- Se você quer MESMO misturar diretórios, ok.
        -- Senão, remove isso e deixa o roam cuidar do diretório dele.
        -- org_files = { "~/orgfiles/**/*" },
      })
    end,
  },

  -- Sniprun (eu moveria pra outro arquivo, mas deixei aqui revisado)
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    cmd = { "SnipRun" },
    config = function()
      require("sniprun").setup({})
    end,
  },
}
