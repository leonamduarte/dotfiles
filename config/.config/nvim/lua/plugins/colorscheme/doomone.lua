return {
  {
    "bashln/Doom-One.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
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
        variable = "#dcaeea",
      },
      highlights = function(c)
        return {
          Identifier = { fg = c.variable },
          Function = { fg = c.magenta },
          Type = { fg = c.yellow },
          Constant = { fg = c.violet },
          String = { fg = c.green },
          Number = { fg = c.orange },
          Boolean = { fg = c.orange },
          Keyword = { fg = c.blue },
          Operator = { fg = c.blue },
          Delimiter = { fg = c.base7 },

          ["@variable"] = { fg = c.variable },
          ["@variable.builtin"] = { fg = c.magenta },
          ["@variable.parameter"] = { fg = c.orange },
          ["@variable.parameter.builtin"] = { fg = c.orange },
          ["@variable.member"] = { fg = c.cyan },
          ["@property"] = { fg = c.cyan },

          ["@function"] = { fg = c.magenta },
          ["@function.call"] = { fg = c.magenta },
          ["@function.method"] = { fg = c.cyan },
          ["@function.method.call"] = { fg = c.cyan },
          ["@function.builtin"] = { fg = c.magenta },
          ["@function.macro"] = { fg = c.violet },

          ["@constructor"] = { fg = c.yellow },
          ["@type"] = { fg = c.yellow },
          ["@type.builtin"] = { fg = c.yellow },
          ["@type.definition"] = { fg = c.yellow },
          ["@module"] = { fg = c.yellow },
          ["@attribute"] = { fg = c.yellow },

          ["@constant"] = { fg = c.violet },
          ["@constant.builtin"] = { fg = c.orange },
          ["@constant.macro"] = { fg = c.violet },
          ["@string"] = { fg = c.green },
          ["@string.escape"] = { fg = c.orange },
          ["@number"] = { fg = c.orange },
          ["@boolean"] = { fg = c.orange },

          ["@keyword"] = { fg = c.blue },
          ["@keyword.function"] = { fg = c.blue },
          ["@keyword.return"] = { fg = c.blue },
          ["@keyword.import"] = { fg = c.blue },
          ["@keyword.operator"] = { fg = c.blue },
          ["@operator"] = { fg = c.blue },

          ["@lsp.type.variable"] = { fg = c.variable },
          ["@lsp.type.parameter"] = { fg = c.orange },
          ["@lsp.type.property"] = { fg = c.cyan },
          ["@lsp.type.function"] = { fg = c.magenta },
          ["@lsp.type.method"] = { fg = c.cyan },
          ["@lsp.type.type"] = { fg = c.yellow },
          ["@lsp.type.namespace"] = { fg = c.yellow },
          ["@lsp.type.enumMember"] = { fg = c.violet },
          ["@lsp.typemod.variable.readonly"] = { fg = c.violet },
          ["@lsp.typemod.variable.defaultLibrary"] = { fg = c.magenta },
        }
      end,
    },
    config = function(_, opts)
      require("doom-one").setup(opts)
      vim.cmd.colorscheme("doom-one")
    end,
  },
}
