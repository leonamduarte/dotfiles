-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local path_nav = require("config.path_navigation")

local function fuzzy(...)
  require("fzf-lua").fzf(...)
end

-- ===== Arquivos / Gerenciadores =====
map("n", "-", "<cmd>Oil --float<CR>", { desc = "Oil: Parent (float)" })
map("n", "<leader>.", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })

map("n", "<leader>fp", function()
  path_nav.browse_path(path_nav._last_dir or vim.uv.cwd())
end, { desc = "Browse path (Emacs-style)" })

map("n", "<leader>fd", function()
  local items = {}
  for c = string.byte("A"), string.byte("Z") do
    local drive = string.char(c) .. ":/"
    if vim.fn.isdirectory(drive) == 1 then
      table.insert(items, drive)
    end
  end
  fuzzy(items, {
    prompt = "Drives> ",
    actions = function(selected)
      if selected[1] then
        path_nav.browse_path(selected[1])
      end
    end,
  })
end, { desc = "Pick drive / root" })

-- Neo-tree explorer (use <leader>fe for fzf files)
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer NeoTree" })

map("n", "<leader>fe", function()
  local name = vim.api.nvim_buf_get_name(0)
  local dir = (name ~= "" and vim.fn.fnamemodify(name, ":p:h")) or vim.loop.cwd()
  require("fzf-lua").fzf_exec("ls -la", {
    cwd = dir,
    prompt = "Files> ",
  })
end, { desc = "FZF Files (aqui)" })

-- ===== Indentação visual =====
map("v", "<", "<gv", { desc = "Indent -" })
map("v", ">", ">gv", { desc = "Indent +" })

-- ===== Paste/Del "limpos" =====
map("v", "p", '"_dP', opts)
map("n", "p", '"_dP', opts)
map("n", "x", '"_x', opts)

-- ===== Salvar =====
map({ "n", "i" }, "<C-s>", function()
  vim.cmd("write")
end, { desc = "Salvar arquivo" })

-- ===== Mover linhas =====
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Mover linha ↓" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Mover linha ↑" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover seleção ↓" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover seleção ↑" })

-- ===== Workspaces (bufstate) =====
map("n", "<leader>qn", ":BufstateNew<CR>", { desc = "Workspace: New" })
map("n", "<leader>qs", ":BufstateSave<CR>", { desc = "Workspace: Save" })
map("n", "<leader>qS", ":BufstateSaveAs<CR>", { desc = "Workspace: Save As" })
map("n", "<leader>ql", ":BufstateLoad<CR>", { desc = "Workspace: Load" })
map("n", "<leader>qD", ":BufstateDelete<CR>", { desc = "Workspace: Delete session" })
map("n", "<leader>qp", ":BufstateList<CR>", { desc = "Workspace: List" })
map("n", "<leader>qw", ":BufstateLoad<CR>", { desc = "Workspace: Switch" })

map("n", "<leader><tab>w", function()
  local tabs = {}
  for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    local title = name == "" and "[Empty]" or vim.fn.fnamemodify(name, ":t")
    table.insert(tabs, string.format("Tab %d: %s", i, title))
  end
  fuzzy(tabs, {
    prompt = "Tabs> ",
    actions = function(selected)
      if selected[1] then
        local tabnr = tonumber(selected[1]:match("Tab (%d+):"))
        if tabnr then
          vim.cmd(tabnr .. "tabnext")
        end
      end
    end,
  })
end, { desc = "List all tabs" })

map("n", "<leader>qN", "<cmd>tabnew | Yazi cwd<CR>", { desc = "Workspace: New tab + Yazi" })

-- ===== Markdown folding =====
require("config.markdown-folding")

-- ===== Abrir arquivo no gerenciador =====
local function open_in_file_manager()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    print("No file is currently open")
    return
  end

  if vim.fn.has("macunix") == 1 then
    vim.fn.system("open -R " .. vim.fn.shellescape(file_path))
  elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.fn.system("explorer /select," .. vim.fn.shellescape(file_path))
  else
    vim.notify("Open in file manager not supported on this OS", vim.log.levels.WARN)
  end
end

map({ "n", "v", "i" }, "<M-f>", open_in_file_manager, { desc = "Open current file in file explorer" })
map("n", "<leader>fO", open_in_file_manager, { desc = "Open current file in file explorer" })

