local M = {}

M.config = {
  max_depth = 3,
}

-- Table to map accented characters to their non-accented counterparts
local accent_map = {
  ["á"] = "a", ["à"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a",
  ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
  ["í"] = "i", ["ì"] = "i", ["î"] = "i", ["ï"] = "i",
  ["ó"] = "o", ["ò"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o",
  ["ú"] = "u", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
  ["ç"] = "c",
  ["Á"] = "a", ["À"] = "a", ["Â"] = "a", ["Ã"] = "a", ["Ä"] = "a",
  ["É"] = "e", ["È"] = "e", ["Ê"] = "e", ["Ë"] = "e",
  ["Í"] = "i", ["Ì"] = "i", ["Î"] = "i", ["Ï"] = "i",
  ["Ó"] = "o", ["Ò"] = "o", ["Ô"] = "o", ["Õ"] = "o", ["Ö"] = "o",
  ["Ú"] = "u", ["Ù"] = "u", ["Û"] = "u", ["Ü"] = "u",
  ["Ç"] = "c",
}

local function remove_accents(str)
  for k, v in pairs(accent_map) do
    str = str:gsub(k, v)
  end
  return str
end

function M.slugify(text)
  if not text then return "" end
  -- Remove existing links from title if any
  text = text:gsub("%[%[.-%]%[(.-)%]%]", "%1")
  text = text:gsub("%[%[(.-)%]%]", "%1")

  text = text:lower()
  text = remove_accents(text)
  text = text:gsub("[^%w%s%-]", "") -- remove special chars
  text = text:gsub("%s+", "-")      -- replace spaces with hyphens
  text = text:gsub("%-+", "-")      -- collapse hyphens
  text = text:gsub("^%-", "")       -- trim leading hyphen
  text = text:gsub("%-$", "")       -- trim trailing hyphen
  return text
end

function M.get_headings()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local headings = {}
  local toc_info = nil

  for i, line in ipairs(lines) do
    local level_str, title, tags = line:match("^(%*+)%s+(.-)%s*(:[%w:]+:)?$")
    if level_str then
      local level = #level_str
      -- Strip tags from title if they were included in the second capture group
      if tags then
          title = title:gsub("%s*" .. tags:gsub("-", "%%-") .. "$", "")
      end

      if tags and tags:find(":TOC:") then
        toc_info = { line = i, level = level }
      else
        table.insert(headings, {
          level = level,
          title = title,
          line = i,
          slug = M.slugify(title)
        })
      end
    end
  end
  return headings, toc_info
end

function M.update_toc()
  local headings, toc_info = M.get_headings()
  if not toc_info then return end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local end_index = toc_info.line
  for i = toc_info.line + 1, #lines do
    local level_str = lines[i]:match("^(%*+)%s+")
    if level_str and #level_str <= toc_info.level then
      break
    end
    end_index = i
  end

  local toc_content = {}
  -- User requested depth can be passed via a buffer variable or use default
  local max_depth = vim.b.org_toc_depth or M.config.max_depth

  for _, h in ipairs(headings) do
    if h.level <= max_depth then
      local indent = string.rep("*", toc_info.level + h.level)
      table.insert(toc_content, string.format("%s [[#%s][%s]]", indent, h.slug, h.title))
    end
  end

  vim.api.nvim_buf_set_lines(0, toc_info.line, end_index, false, toc_content)
end

function M.jump_to_heading()
  local line = vim.api.nvim_get_current_line()
  local slug = line:match("%[%[#([^%]]+)%]%[.-%]%]")
  if not slug then
    -- Try simple link format [[#slug]]
    slug = line:match("%[%[#([^%]]+)%]%]")
  end

  if not slug then return end

  local headings, _ = M.get_headings()
  for _, h in ipairs(headings) do
    if h.slug == slug then
      vim.api.nvim_win_set_cursor(0, { h.line, 0 })
      -- Center the view
      vim.cmd("normal! zz")
      return true
    end
  end
  return false
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.org",
    callback = function()
      M.update_toc()
    end,
  })

  -- Keymap for navigation
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "org",
    callback = function()
      vim.keymap.set("n", "<CR>", function()
        if not M.jump_to_heading() then
          -- If not a TOC link, fallback to default behavior (which for orgmode might be following a link)
          -- We use feedkeys to avoid recursion if we were to map <CR> to itself
          local key = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
          vim.api.nvim_feedkeys(key, "n", false)
        end
      end, { buffer = true, desc = "Jump to Org heading from TOC" })
    end,
  })
end

return M
