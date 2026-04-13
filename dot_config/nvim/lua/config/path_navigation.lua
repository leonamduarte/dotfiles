local M = {}

M._last_dir = nil

local uv = vim.uv or vim.loop

local function trim(value)
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function add_variant(variants, seen, candidate)
  if not candidate or candidate == "" or seen[candidate] then
    return
  end
  seen[candidate] = true
  table.insert(variants, candidate)
end

function M.is_windows()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

function M.is_unc_path(path)
  if type(path) ~= "string" then
    return false
  end

  return path:sub(1, 2) == "\\\\" or path:sub(1, 2) == "//"
end

function M.normalize_path(path)
  if type(path) ~= "string" then
    return ""
  end

  local normalized = trim(path)
  if normalized == "" then
    return ""
  end

  normalized = vim.fn.expand(normalized)

  if M.is_unc_path(normalized) then
    if normalized:sub(1, 2) == "//" then
      normalized = "\\\\" .. normalized:sub(3)
    end

    normalized = normalized:gsub("/", "\\")

    if normalized:sub(1, 1) == "\\" and normalized:sub(2, 2) ~= "\\" then
      normalized = "\\" .. normalized
    end
  end

  return normalized
end

function M.path_variants(path)
  local variants = {}
  local seen = {}
  local normalized = M.normalize_path(path)

  add_variant(variants, seen, normalized)
  add_variant(variants, seen, vim.fn.fnamemodify(normalized, ":p"))

  if M.is_unc_path(normalized) then
    add_variant(variants, seen, normalized:gsub("\\", "/"))
  else
    add_variant(variants, seen, normalized:gsub("\\", "/"))
    add_variant(variants, seen, normalized:gsub("/", "\\"))
  end

  return variants
end

function M.join_path(base, child)
  if not base or base == "" then
    return child
  end

  if not child or child == "" then
    return base
  end

  local sep = "/"
  if M.is_unc_path(base) or base:match("\\") then
    sep = "\\"
  end

  local clean_base = base:gsub(sep .. "+$", "")
  return clean_base .. sep .. child
end

function M.directory_exists(path)
  for _, candidate in ipairs(M.path_variants(path)) do
    if vim.fn.isdirectory(candidate) == 1 then
      return true, candidate
    end

    local ok, stat = pcall(uv.fs_stat, candidate)
    if ok and stat and stat.type == "directory" then
      return true, candidate
    end
  end

  return false, nil
end

function M.file_exists(path)
  for _, candidate in ipairs(M.path_variants(path)) do
    if vim.fn.filereadable(candidate) == 1 then
      return true, candidate
    end

    local ok, stat = pcall(uv.fs_stat, candidate)
    if ok and stat and stat.type == "file" then
      return true, candidate
    end
  end

  return false, nil
end

function M.open_oil(path)
  local ok, oil = pcall(require, "oil")
  if not ok then
    vim.notify("oil.nvim is not available", vim.log.levels.ERROR)
    return false
  end

  local open_ok, err = pcall(oil.open, path)
  if not open_ok then
    vim.notify("Failed to open directory: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.open_find_path(input_path)
  local normalized = M.normalize_path(input_path)
  if normalized == "" then
    vim.notify("Path is required", vim.log.levels.WARN)
    return false
  end

  local is_dir, directory_path = M.directory_exists(normalized)
  if is_dir then
    return M.open_oil(directory_path or normalized)
  end

  local edit_ok, err = pcall(vim.cmd, "edit " .. vim.fn.fnameescape(normalized))
  if not edit_ok then
    vim.notify("Failed to open path: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.browse_path(start_dir)
  start_dir = start_dir or uv.cwd()
  start_dir = M.normalize_path(start_dir)
  M._last_dir = start_dir

  local items = {}

  -- Add ".." unless we're at a drive root (e.g. C:/ or C:\)
  local parent = vim.fn.fnamemodify(start_dir, ":h")
  if parent ~= start_dir then
    table.insert(items, { text = "../", _full_path = parent, _is_dir = true })
  end

  -- Read directory contents
  local ok, handle = pcall(uv.fs_opendir, start_dir, nil, 100)
  if ok and handle then
    while true do
      local entries = uv.fs_readdir(handle)
      if not entries then
        break
      end
      for _, entry in ipairs(entries) do
        local full = M.join_path(start_dir, entry.name)
        local is_dir = entry.type == "directory"
        table.insert(items, {
          text = entry.name .. (is_dir and "/" or ""),
          _full_path = full,
          _is_dir = is_dir,
        })
      end
    end
    uv.fs_closedir(handle)
  else
    vim.notify("Cannot read directory: " .. start_dir, vim.log.levels.WARN)
    return
  end

  local ok_fzf, fzf = pcall(require, "fzf-lua")
  if not ok_fzf then
    return M.open_oil(start_dir)
  end

  local items_str = {}
  for _, item in ipairs(items) do
    table.insert(items_str, item.text)
  end

  fzf.fzf(items_str, {
    prompt = start_dir .. " ",
    actions = function(selected)
      if selected and selected[1] then
        local selected_item = nil
        for _, item in ipairs(items) do
          if item.text == selected[1] then
            selected_item = item
            break
          end
        end
        if selected_item then
          if selected_item._is_dir then
            M.browse_path(selected_item._full_path)
          else
            M.open_find_path(selected_item._full_path)
          end
        end
      end
    end,
  })
end

function M.is_hidden_windows(path)
  if not M.is_windows() then
    return false
  end

  local escaped = vim.fn.shellescape(path)
  local output = vim.fn.systemlist("attrib " .. escaped)
  if vim.v.shell_error ~= 0 or not output or #output == 0 then
    return false
  end

  local first_line = output[1] or ""
  return first_line:match("%f[%a]H%f[%A]") ~= nil
end

-- Auto-sync _last_dir quando o cwd do Neovim muda (qualquer ferramenta)
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    M._last_dir = M.normalize_path(vim.uv.cwd())
  end,
})

-- Auto-sync _last_dir ao navegar em buffers oil (oil não muda o cwd)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "oil://*",
  callback = function()
    local ok, oil = pcall(require, "oil")
    if ok then
      local dir = oil.get_current_dir()
      if dir then
        M._last_dir = M.normalize_path(dir)
      end
    end
  end,
})

-- Auto-sync _last_dir ao entrar em qualquer arquivo real
-- Cobre: recent files do dashboard, pickers, :e, gf, etc.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= "" then return end   -- ignora terminal, quickfix, etc.
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" or name:match("^oil://") then return end
    local dir = M.normalize_path(vim.fn.fnamemodify(name, ":p:h"))
    if dir ~= "" and dir ~= M._last_dir then
      M._last_dir = dir
    end
  end,
})

return M
