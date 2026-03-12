return {
  "saghen/blink.cmp",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = function(_, opts)
    opts.completion = opts.completion or {}
    opts.completion.list = opts.completion.list or {}
    opts.completion.list.selection = vim.tbl_deep_extend("force", opts.completion.list.selection or {}, {
      preselect = false,
      auto_insert = true,
    })

    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      ["<C-n>"] = { "select_next", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
    })

    return opts
  end,
}
