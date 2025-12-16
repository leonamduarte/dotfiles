return {
  -- 1. ORGMODE (O Cérebro)
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup principal
      require("orgmode").setup({
        -- CAMINHOS: Usamos vim.fn.expand para garantir que o Linux entenda o "~/"
        org_agenda_files = { "~/org/**/*" },
        org_default_notes_file = vim.fn.expand("~/org/inbox.org"),

        -- KEYWORDS (Idêntico ao seu Doom Emacs)
        org_todo_keywords = {
          "TODO(t)",
          "IN-PROGRESS(i)",
          "WAIT(w)",
          "PROJ(p)",
          "|",
          "DONE(d)",
          "CANCELLED(c)",
        },

        -- APARÊNCIA & COMPORTAMENTO
        org_ellipsis = " ▼ ",
        org_hide_emphasis_markers = true, -- Requer vim.opt.conceallevel = 2
        org_log_done = "time", -- Loga a hora que terminou
        -- org_log_into_drawer = true, -- Joga o log dentro de :LOGBOOK:

        -- AGENDA
        org_agenda_start_on_weekday = false,
        org_agenda_span = 1,
        org_agenda_skip_scheduled_if_done = true,
        org_agenda_skip_deadline_if_done = true,

        -- SUPER AGENDA CUSTOMIZADA (Simulando o agrupamento visual)
        org_agenda_custom_commands = {
          o = {
            description = "Visão Geral (Otimizada)",
            types = {
              { type = "agenda", label = "🗓  Hoje", overridden = "k" },
              { type = "tags_todo", match = '+PRIORITY="A"', label = "🔥 Urgente" },
              { type = "tags", match = "project", label = "📦 Projetos" },
              { type = "tags", match = '+TODO="WAIT"', label = "⏳ Aguardando" },
            },
          },
        },
      })

      -- --- AUTOMAÇÃO (AUTO-TANGLE) ---
      -- Função para inserir a tag no topo do arquivo
      local function insert_auto_tangle()
        local line = "#+auto_tangle: t"
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { line })
        print("Tag auto_tangle inserida.")
      end

      -- Autocmd: Ao salvar, verifica se existe a tag e roda o tangle
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.org",
        callback = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          for _, line in ipairs(lines) do
            if line:match("#%+auto_tangle: t") then
              -- Roda o tangle assincronamente para não travar o editor
              vim.schedule(function()
                vim.cmd("Org Tangle")
                print("♻️  Auto-tangled com sucesso.")
              end)
              return
            end
          end
        end,
      })

      -- --- MAPS (Atalhos estilo Doom) ---
      local map = vim.keymap.set
      map("n", "<leader>oa", function()
        require("orgmode").action("agenda.prompt")
      end, { desc = "Org Agenda" })
      map("n", "<leader>oc", function()
        require("orgmode").action("capture.prompt")
      end, { desc = "Org Capture" })
      map("n", "<leader>mB", function()
        require("orgmode").action("org_mappings.org_babel_tangle")
      end, { desc = "Org Babel Tangle" })
      map("n", "<leader>ia", insert_auto_tangle, { desc = "Insert Auto Tangle Tag" })
    end,
  },

  -- 2. HEADLINES (A Maquiagem)
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "org" }, -- Carrega apenas em arquivos org
    config = function()
      require("headlines").setup({
        -- Otimização: Desativamos em markdown para não gastar recurso à toa
        markdown = { enable = false },
        org = {
          -- headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4" },
          bullets = { "◉", "●", "○", "◆", "●", "○", "◆" },
        },
      })
    end,
  },
}
