return {
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local ws_ok, workspaces = pcall(require, "workspaces")
      if not ws_ok then
        return
      end

      local ws_component = {
        function()
          local name = workspaces.name()
          return name and ("[P] " .. name) or ""
        end,
        cond = function()
          local ok, ws = pcall(require, "workspaces")
          return ok and ws.name() ~= nil
        end,
      }

      if opts.sections and opts.sections.lualine_c then
        table.insert(opts.sections.lualine_c, 1, ws_component)
      end
    end,
  },
}
