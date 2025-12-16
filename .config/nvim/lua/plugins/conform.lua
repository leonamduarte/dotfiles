return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- Garante que a tabela existe antes de inserir dados
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Adiciona o Prettier para as linguagens Web
    opts.formatters_by_ft.css = { "prettier" }
    opts.formatters_by_ft.scss = { "prettier" }
    opts.formatters_by_ft.html = { "prettier" }
    opts.formatters_by_ft.json = { "prettier" }
    opts.formatters_by_ft.javascript = { "prettier" }
    opts.formatters_by_ft.typescript = { "prettier" }
    opts.formatters_by_ft.javascriptreact = { "prettier" } -- React (.jsx)
    opts.formatters_by_ft.typescriptreact = { "prettier" } -- React (.tsx)
    opts.formatters_by_ft.vue = { "prettier" }
    opts.formatters_by_ft.astro = { "prettier" }
    opts.formatters = opts.formatters or {}
    opts.formatters.prettier = function()
      local bin = vim.fn.executable("prettierd") == 1 and "prettierd" or "prettier"
      return { cmd = bin, args = { "--stdin-filepath", "$FILENAME" }, stdin = true }
    end
  end,
}
