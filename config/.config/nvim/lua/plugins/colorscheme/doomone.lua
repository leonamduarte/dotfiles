return {
  {
    "bashln/Doom-One.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      background = "dark",
      styles = {
        comments = { italic = true },
        conditionals = { italic = true },
        functions = {},
        keywords = {},
        properties = {},
        types = {},
        variables = {},
      },
      colors = {
        -- Paleta exata do doom-one-theme.el
        bg = "#282c34",
        fg = "#bbc2cf",
        bg_alt = "#21242b",
        base0 = "#1B2229",
        base1 = "#1c1f24",
        base2 = "#202328",
        base3 = "#23272e",
        base4 = "#3f444a", -- grey
        base5 = "#5B6268",
        base6 = "#73797e",
        base7 = "#9ca0a4",
        base8 = "#DFDFDF",
        grey = "#3f444a",
        red = "#ff6c6b",
        orange = "#da8548",
        green = "#98be65",
        teal = "#4db5bd",
        yellow = "#ECBE7B",
        blue = "#51afef",
        dark_blue = "#2257A0",
        magenta = "#c678dd",
        violet = "#a9a1e1",
        cyan = "#46D9FF",
        dark_cyan = "#5699AF",
        variable = "#dcaeea", -- (doom-lighten magenta 0.4)
      },
      highlights = function(c)
        return {
          -- UI Elements (Baseado no line-number &override do .el)
          LineNr = { fg = c.base4 },
          CursorLineNr = { fg = c.fg },
          Visual = { bg = c.dark_blue }, -- (selection dark-blue)

          -- Syntax Core (Universal syntax classes do Doom)
          Identifier = { fg = c.variable },
          Function = { fg = c.magenta },
          Type = { fg = c.yellow },
          Constant = { fg = c.violet },
          String = { fg = c.green },
          Number = { fg = c.orange },
          Boolean = { fg = c.violet }, -- No Emacs: constants = violet
          Keyword = { fg = c.blue },
          Operator = { fg = c.blue },
          Delimiter = { fg = c.base7 },
          Comment = { fg = c.base5 }, -- (comments base5)

          -- TreeSitter
          ["@variable"] = { fg = c.variable },
          ["@variable.builtin"] = { fg = c.magenta }, -- (builtin magenta)
          ["@variable.parameter"] = { fg = c.orange },
          ["@variable.member"] = { fg = c.cyan }, -- (methods cyan)
          ["@property"] = { fg = c.cyan },

          ["@function"] = { fg = c.magenta },
          ["@function.builtin"] = { fg = c.magenta },
          ["@function.method"] = { fg = c.cyan },
          ["@function.macro"] = { fg = c.violet },

          ["@constructor"] = { fg = c.yellow },
          ["@type"] = { fg = c.yellow },
          ["@type.builtin"] = { fg = c.yellow },
          ["@module"] = { fg = c.yellow },
          ["@attribute"] = { fg = c.orange }, -- (css-proprietary-property orange)

          ["@constant"] = { fg = c.violet },
          ["@constant.builtin"] = { fg = c.violet },
          ["@constant.macro"] = { fg = c.violet },
          ["@string"] = { fg = c.green },
          ["@number"] = { fg = c.orange },
          ["@boolean"] = { fg = c.violet },

          ["@keyword"] = { fg = c.blue },
          ["@keyword.operator"] = { fg = c.blue },
          ["@operator"] = { fg = c.blue },

          -- LSP
          ["@lsp.type.variable"] = { fg = c.variable },
          ["@lsp.type.parameter"] = { fg = c.orange },
          ["@lsp.type.property"] = { fg = c.cyan },
          ["@lsp.type.function"] = { fg = c.magenta },
          ["@lsp.type.method"] = { fg = c.cyan },
          ["@lsp.type.type"] = { fg = c.yellow },
          ["@lsp.typemod.variable.defaultLibrary"] = { fg = c.magenta },
          ["@lsp.typemod.variable.readonly"] = { fg = c.violet },

          -- Markdown (Baseado no markdown-header-face &override do .el)
          ["@markup.heading"] = { fg = c.red, bold = true },
          ["@markup.raw"] = { bg = c.base3 },
          ["@markup.link.label"] = { fg = c.blue },
        }
      end,
    },
    config = function(_, opts)
      require("doom-one").setup(opts)
      vim.cmd.colorscheme("doom-one")
    end,
  },
}
