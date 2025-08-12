return {
  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("lazy").setup({
      background = "medium",
      transparent_background_level = 0,
      italics = true,
      disable_italic_comments = false,
      inlay_hints_background = "dimmed",
      on_highlights = function(hl, _)
        hl["@string.special.symbol.ruby"] = { link = "@field" }
      end,
    })
  end,
}
