-- =============================
-- lua/plugins/snacks.lua
-- (centraliza módulos do Snacks + chaves)
-- =============================
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        sources = {
          explorer = {
            layout = {
              layout = {
                position = "right",
              },
            },
          },
        },
      },
      explorer = { enabled = true },
      notifier = { enabled = true },
      dashboard = { enabled = true },
      quickfile = { enabled = true },
      -- se quiser customizar layouts do picker:
      -- picker = { layout = { preset = "ivy" } },
    },
  },
}
