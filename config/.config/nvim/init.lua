-- ===== ShaDa Cleanup & Prevention =====
-- Clean stale ShaDa temp files to prevent E138 errors
-- This fixes "recent files" (SPC f r) not persisting
--
-- If E138 error persists after cleanup, check:
-- - Antivirus/sync tools locking files in AppData\Local
-- - Neovim crashing on exit (leaving orphan .tmp files)
-- - Multiple Neovim instances running concurrently
local function cleanup_shada_tmp()
  local shada_dir = vim.fn.stdpath("data") .. "/shada"
  local ok, uv = pcall(require, "vim.uv")
  if not ok then
    ok, uv = pcall(require, "luv")
  end
  if not ok or not uv then
    vim.notify("ShaDa: uv/lua not available - cleanup skipped", vim.log.levels.WARN)
    return
  end

  local entries = uv.fs_scandir(shada_dir)
  if not entries then
    vim.notify("ShaDa: cannot scan directory - cleanup skipped", vim.log.levels.WARN)
    return
  end

  local cleaned = 0
  while true do
    local name = uv.fs_scandir_next(entries)
    if not name then break end
    if name:match("^main%.shada%.tmp%.[a-z]$") then
      local path = shada_dir .. "/" .. name
      local unlink_ok = uv.fs_unlink(path)
      if not unlink_ok then
        vim.notify("ShaDa: failed to delete " .. name, vim.log.levels.WARN)
      else
        cleaned = cleaned + 1
      end
    end
  end

  if cleaned > 0 then
    vim.notify("ShaDa: cleaned " .. cleaned .. " temp file(s)", vim.log.levels.DEBUG)
  end
end

cleanup_shada_tmp()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
