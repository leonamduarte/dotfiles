-- https://github.com/catppuccin/nvim

return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  opts = {
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "latte",
      dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { "italic" }, -- Change the style of comments
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    default_integrations = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
    custom_highlights = function(colors)
      return {

        -- Chages the color on a little line on the left side of the currently
        -- selected tab
        TabLineSel = { bg = "#32D1FD" },

        -- Change the text color of the currently selected buffer
        BufferLineBufferSelected = { fg = "#32D1FD" },

        -- nvim spectre highlight colors
        DiffChange = { bg = "#a6e3a1", fg = "black" },
        DiffDelete = { bg = "#f38ba8", fg = "black" },

        -- visual mode highlighted text color
        Visual = { bg = "#7ec9d8", fg = "white" },

        -- horizontal line that goes across where cursor is
        CursorLine = { bg = "#3f404f" },
        -- CursorLine = { bg = "#ff2800" },

        -- Color of repeated words
        illuminatedWordText = { bg = "#5886b0" },
        -- Default value
        -- illuminatedWordText = { bg = "#6a6b7a" },
        -- IlluminatedWordText = { bg = "#a6e3a1", fg = "#5c4696" },
        -- IlluminatedWordRead = { bg = "#a6e3a1", fg = "#5c4696" },
        -- IlluminatedWordWrite = { bg = "#a6e3a1", fg = "#5c4696" },
        -- IlluminatedWordText = { bg = "#f38ba8", fg = "#a6e3a1" },
        -- IlluminatedWordRead = { bg = "#f38ba8", fg = "#a6e3a1" },
        -- IlluminatedWordWrite = { bg = "#f38ba8", fg = "#a6e3a1" },

        -- -- I moved these colors to the lukas-reineke/headlines.nvim plugin
        -- -- Heading colors I use in my markdown files
        -- Headline1 = { bg = "#295715", fg = "white" },
        -- Headline2 = { bg = "#8d8200", fg = "white" },
        -- Headline3 = { bg = "#a56106", fg = "white" },
        -- Headline4 = { bg = "#7e0000", fg = "white" },
        -- Headline5 = { bg = "#1e0b7b", fg = "white" },
        -- darker codeblock for my markdown files
        -- CodeBlock = { bg = "#09090d" },

        -- I haven't tested all of the ones below, so test at your own will
        --     Search = { bg = "#569CD6", fg = "#1E1E1E" },
        --     IncSearch = { bg = "#C586C0", fg = "#1E1E1E" },
        --     MatchParen = { bg = "#FFD700", fg = "#000000" },
        --     Highlight = { bg = "#32CD32", fg = "#000000" },
        --     QuickFixLine = { bg = "#ADD8E6", fg = "#000000" },
        Comment = { fg = colors.flamingo },
        --     TabLineSel = { bg = colors.pink },
        --     CmpBorder = { fg = colors.surface2 },
        --     Pmenu = { bg = colors.none },
      }
    end,
  },
}
