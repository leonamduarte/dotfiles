-- =============================
-- lua/plugins/test.lua
-- (neotest core já vem pelo extra; aqui plugamos adapters)
-- =============================

-- lua/plugins/test.lua
-- Neotest + Vitest (com root/cwd robustos) + integrações úteis

return {
  -- Adapters opcionais (carregam sob demanda)
  { "nvim-neotest/neotest-plenary", lazy = true },
  { "marilari88/neotest-vitest", lazy = true },
  { "V13Axel/neotest-pest", lazy = true }, -- se usar Pest (PHP)
  { "fredrikaverpil/neotest-golang", lazy = true }, -- se usar Go

  {
    "nvim-neotest/neotest",
    -- Se o extra `lazyvim.plugins.extras.test.core` estiver ativo, este spec apenas ESTENDE o existente.
    optional = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "folke/trouble.nvim",
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.adapters = opts.adapters or {}

      -- ===== Vitest adapter (única definição) =====
      local lib = require("neotest.lib")
      table.insert(
        opts.adapters,
        require("neotest-vitest")({
          -- Use SEMPRE uma tabela {} no construtor (evita 'opts' nil em algumas versões)
          -- Raiz/CWD: ancora ao mesmo root que o Vitest usaria
          cwd = function(path)
            return (
              lib.files.match_root_pattern(
                "vitest.config.ts",
                "vitest.config.js",
                "vite.config.ts",
                "vite.config.js",
                "package.json",
                ".git"
              )(path)
            ) or vim.fn.getcwd()
          end,
          -- Comando correto conforme o gerenciador do projeto
          vitestCommand = function()
            if vim.fn.filereadable("pnpm-lock.yaml") == 1 then
              return "pnpm vitest"
            end
            if vim.fn.filereadable("yarn.lock") == 1 then
              return "yarn vitest"
            end
            if vim.fn.filereadable("package-lock.json") == 1 then
              return "npx vitest"
            end
            return "vitest"
          end,
          -- Evitar diretórios “lixo”
          filter_dir = function(name, _)
            return not name:match("^node_modules$") and not name:match("^dist$")
          end,
        })
      )

      -- (Opcional) outros adapters, só se existirem
      local ok_plenary, plenary = pcall(require, "neotest-plenary")
      if ok_plenary then
        table.insert(opts.adapters, plenary)
      end

      local ok_pest, pest = pcall(require, "neotest-pest")
      if ok_pest then
        table.insert(opts.adapters, pest({}))
      end

      local ok_go, go = pcall(require, "neotest-golang")
      if ok_go then
        table.insert(opts.adapters, go({}))
      end

      -- ===== Qualidade de vida =====
      opts.status = vim.tbl_deep_extend("force", { virtual_text = true }, opts.status or {})
      opts.output = vim.tbl_deep_extend("force", { open_on_run = true }, opts.output or {})

      -- Quickfix -> Trouble (com fallback)
      opts.quickfix = {
        open = function()
          local ok, trouble = pcall(require, "trouble")
          if ok then
            trouble.open({ mode = "quickfix", focus = false })
          else
            vim.cmd("copen")
          end
        end,
      }

      -- Virtual text “limpo” no namespace do neotest
      do
        local ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
          virtual_text = {
            format = function(d)
              return d.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            end,
          },
        }, ns)
      end

      -- Consumer: refresca/fecha Trouble quando tudo passa
      opts.consumers = opts.consumers or {}
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))
          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == "failed" and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local ok, trouble = pcall(require, "trouble")
            if ok and trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
        end
        return {}
      end

      return opts
    end,

    -- ===== Keymaps defensivos (não quebram se plugin atrasar) =====
    keys = {
      {
        "<leader>tf",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.run and nt.run.run then
            nt.run.run(vim.fn.expand("%"))
          end
        end,
        desc = "Neotest: Run file",
      },
      {
        "<leader>tn",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.run and nt.run.run then
            nt.run.run()
          end
        end,
        desc = "Neotest: Run nearest",
      },
      {
        "<leader>ts",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.summary then
            nt.summary.toggle()
          end
        end,
        desc = "Neotest: Toggle summary",
      },
      {
        "<leader>to",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.output then
            nt.output.open({ enter = true, auto_close = true })
          end
        end,
        desc = "Neotest: Show output",
      },
      {
        "<leader>tO",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.output_panel then
            nt.output_panel.toggle()
          end
        end,
        desc = "Neotest: Toggle output panel",
      },
      {
        "<leader>tS",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.run and nt.run.stop then
            nt.run.stop()
          end
        end,
        desc = "Neotest: Stop",
      },
      {
        "<leader>td",
        function()
          local ok, nt = pcall(require, "neotest")
          if ok and nt.run and nt.run.run then
            nt.run.run({ strategy = "dap" })
          end
        end,
        desc = "Neotest: Debug nearest (DAP)",
      },
    },
  },
}
