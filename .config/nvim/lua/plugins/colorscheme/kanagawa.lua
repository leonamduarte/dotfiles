return {
  "rebelot/kanagawa.nvim",
  enabled = false,
  priority = 1000, -- garante que o tema carrega antes de tudo
  config = function()
    vim.o.background = "dark" -- importante definir antes

    require("kanagawa").setup({
      compile = true, -- compila em bytecode (startup mais rápido)
      undercurl = true,
      transparent = false, -- mude pra true se usar terminal com blur
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
        local makeDiagnosticColor = function(color)
          local c = require("kanagawa.lib.color")
          return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
        end

        return {
          -- Assign a static color to strings
          String = { fg = colors.palette.carpYellow, italic = true },
          -- theme colors will update dynamically when you change theme!
          SomePluginHl = { fg = colors.theme.syn.type, bold = true },

          -- Flutuantes limpos e modernos
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },

          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          -- Linha atual mais sutil
          CursorLine = { bg = theme.ui.bg_p1 },

          -- Diagnósticos menos agressivos
          DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
          DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
          DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
          DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

          -- Popup de autocomplete mais elegante
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          -- Telescope estilo “bloco”
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
        }
      end,
    })

    -- vim.cmd("colorscheme kanagawa")
  end,
}
