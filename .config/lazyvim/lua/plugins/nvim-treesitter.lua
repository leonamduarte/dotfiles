return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- só para habilitar o módulo
    },
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "blade",
        "c",
        "caddy",
        "css",
        "diff",
        "dockerfile",
        "editorconfig",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "nginx",
        "php",
        "php_only",
        "python",
        "sql",
        "typescript",
        "vim",
        "vimdoc",
        "ninja",
        "rst",
      },
      auto_install = true,

      -- highlight/indent padrão
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },

      -- incremental_selection (agora DENTRO de opts)
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },

      -- textobjects (também DENTRO de opts)
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ao"] = "@comment.outer",
            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v",      -- charwise
            ["@function.outer"]  = "V",      -- linewise
            ["@class.outer"]     = "<c-v>",  -- blockwise
          },
          include_surrounding_whitespace = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
  },
}

