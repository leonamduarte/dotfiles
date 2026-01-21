return {
  "rebelot/kanagawa.nvim",
  priority = 1000, -- garante que o tema carrega antes de tudo
  config = function()
    vim.o.background = "dark" -- importante definir antes

    require("kanagawa").setup({
      compile = true, -- compila em bytecode (startup mais rápido)
      undercurl = true,
      transparent = true, -- mude pra true se usar terminal com blur
      dimInactive = true,

      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      functionStyle = {},
      typeStyle = {},

      terminalColors = true,

      theme = "wave", -- wave equilibrado; dragon é ótimo à noite

      background = {
        dark = "wave",
        light = "lotus",
      },

      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- remove fundo da coluna de números
            },
          },
        },
      },

      overrides = function(colors)
        local theme = colors.theme

        return {
          -- Flutuantes limpos e modernos
          NormalFloat = { bg = "none" },
          FloatBorder = { fg = theme.ui.bg_p2, bg = "none" },

          -- Linha atual mais sutil
          CursorLine = { bg = theme.ui.bg_p1 },

          -- Diagnósticos menos agressivos
          DiagnosticVirtualTextHint = { fg = theme.diag.hint },
          DiagnosticVirtualTextInfo = { fg = theme.diag.info },
          DiagnosticVirtualTextWarn = { fg = theme.diag.warning },
          DiagnosticVirtualTextError = { fg = theme.diag.error },

          -- Popup de autocomplete mais elegante
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { bg = theme.ui.bg_p2 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          -- Telescope estilo “bloco”
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewBorder = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
        }
      end,
    })

    vim.cmd("colorscheme kanagawa")
  end,
}
