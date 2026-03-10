local M = {}

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

function M.is_hidden_windows(path)
  if not M.is_windows() then
    return false
  end

  local escaped = path:gsub("/", "\\")
  local output = vim.fn.systemlist('attrib "' .. escaped .. '"')
  if vim.v.shell_error ~= 0 or not output or #output == 0 then
    return false
  end

  local first_line = output[1] or ""
  return first_line:match("%f[%a]H%f[%A]") ~= nil
end

return M
