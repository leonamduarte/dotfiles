-- =============================
-- lua/plugins/project.lua
-- (Project.nvim já vem via extra util.project; aqui só ajustes)
-- =============================
return {
  {
    "ahmedkhalf/project.nvim",
    optional = true,
    opts = {
      detection_methods = { "pattern" },
      patterns = { ".git", "package.json", "pyproject.toml", "flake.nix" },
    },
  },
}
