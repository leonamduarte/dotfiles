-- ~/.config/nvim/lua/plugins/windows-drives.lua
-- Atalhos rápidos para drives do Windows (estilo Doom Emacs melhorado)

local path_nav = require("config.path_navigation")

local function open_unc_share(path)
  local normalized = path_nav.normalize_path(path)
  if normalized == "" then
    vim.notify("UNC path is required", vim.log.levels.WARN)
    return
  end

  if not path_nav.is_unc_path(normalized) and vim.fn.has("win32") == 1 and normalized:match("^%a:[/\\]") == nil then
    vim.notify("Path must be UNC (\\\\server\\share) or drive root", vim.log.levels.ERROR)
    return
  end

  local ok, dir = path_nav.directory_exists(normalized)
  if not ok then
    vim.notify("Directory not found: " .. normalized, vim.log.levels.ERROR)
    return
  end

  path_nav.open_oil(dir or normalized)
end

return {
  {
    "snacks.nvim",
    keys = {
      -- SPC . - Busca no diretório atual do buffer
      {
        "<leader>.",
        function()
          local current_file = vim.fn.expand("%:p:h")
          local dir = (current_file ~= "") and current_file or vim.loop.cwd()
          require("snacks").picker.files({ cwd = dir })
        end,
        desc = "Find files (current buffer dir)",
      },

      -- SPC f f - Busca no cwd do Neovim
      {
        "<leader>ff",
        function()
          require("snacks").picker.files()
        end,
        desc = "Find files (cwd)",
      },

      -- SPC f d - Prompt para escolher diretório (como SPC . + i:/ no Doom)
      {
        "<leader>fd",
        function()
          vim.ui.input({
            prompt = "Directory (e.g., i:/ or c:/projects): ",
            default = vim.loop.cwd(),
            completion = "dir",
          }, function(input)
            if input and input ~= "" then
              local expanded = vim.fn.expand(input)
              if vim.fn.isdirectory(expanded) == 1 then
                require("snacks").picker.files({ cwd = expanded })
              else
                vim.notify("Invalid directory: " .. input, vim.log.levels.ERROR)
              end
            end
          end)
        end,
        desc = "Find files in directory (prompt)",
      },

      {
        "<leader>fus",
        function()
          vim.ui.input({
            prompt = "UNC share (e.g., \\\\server\\share): ",
            default = "\\\\",
            completion = "dir",
          }, function(input)
            if not input or input == "" then
              return
            end

            open_unc_share(input)
          end)
        end,
        desc = "Open UNC share (prompt)",
      },

      {
        "<leader>fus1",
        function()
          open_unc_share(vim.g.unc_share_1 or "I:/")
        end,
        desc = "Open UNC share 1",
      },

      {
        "<leader>fus2",
        function()
          open_unc_share(vim.g.unc_share_2 or "Z:/")
        end,
        desc = "Open UNC share 2",
      },

      -- ========== ATALHOS DIRETOS PARA DRIVES (Windows) ==========

      -- SPC f i - Drive I:/ (seu drive principal pelo visto)
      {
        "<leader>fi",
        function()
          if vim.fn.has("win32") == 1 and vim.fn.isdirectory("i:/") == 1 then
            require("snacks").picker.files({ cwd = "i:/" })
          else
            vim.notify("Drive i:/ not found", vim.log.levels.ERROR)
          end
        end,
        desc = "Find files in I:/",
      },

      -- SPC f c - Drive C:/
      -- {
      --   "<leader>fc",
      --   function()
      --     if vim.fn.has("win32") == 1 then
      --       require("snacks").picker.files({ cwd = "c:/" })
      --     end
      --   end,
      --   desc = "Find files in C:/",
      -- },

      -- SPC f h - Home (~)
      {
        "<leader>fh",
        function()
          require("snacks").picker.files({ cwd = vim.fn.expand("~") })
        end,
        desc = "Find files in home",
      },

      -- SPC f n - Neovim config
      -- {
      --   "<leader>fn",
      --   function()
      --     require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
      --   end,
      --   desc = "Find files in Neovim config",
      -- },

      -- SPC c d - Mudar cwd do Neovim (útil para LSP)
      {
        "<leader>cd",
        function()
          vim.ui.input({
            prompt = "Change cwd to: ",
            default = vim.loop.cwd(),
            completion = "dir",
          }, function(input)
            if input and input ~= "" then
              local expanded = vim.fn.expand(input)
              if vim.fn.isdirectory(expanded) == 1 then
                vim.cmd("cd " .. vim.fn.fnameescape(expanded))
                vim.notify("cwd: " .. vim.loop.cwd(), vim.log.levels.INFO)
              else
                vim.notify("Invalid directory", vim.log.levels.ERROR)
              end
            end
          end)
        end,
        desc = "Change working directory",
      },

      -- SPC c D - Mudar cwd para o diretório do arquivo atual
      {
        "<leader>cD",
        function()
          local dir = vim.fn.expand("%:p:h")
          if dir ~= "" then
            vim.cmd("cd " .. vim.fn.fnameescape(dir))
            vim.notify("cwd: " .. vim.loop.cwd(), vim.log.levels.INFO)
          end
        end,
        desc = "Change cwd to current file",
      },
    },
  },

  -- Yazi com suporte a drives
  {
    "mikavilpas/yazi.nvim",
    optional = true,
    keys = {
      -- SPC . y - Yazi com prompt de diretório
      {
        "<leader>.y",
        function()
          vim.ui.input({
            prompt = "Open Yazi in: ",
            default = vim.loop.cwd(),
            completion = "dir",
          }, function(input)
            if input and input ~= "" then
              local expanded = vim.fn.expand(input)
              if vim.fn.isdirectory(expanded) == 1 then
                vim.cmd("Yazi " .. vim.fn.fnameescape(expanded))
              end
            end
          end)
        end,
        desc = "Yazi in directory (prompt)",
      },
    },
  },
}
