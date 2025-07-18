-- Global Options
vim.opt.cmdheight = 1 -- More space in the Neovim command line for displaying messages
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.mouse = "a" -- Enable mouse mode, useful for resizing splits
vim.opt.undofile = true -- Save undo history
vim.opt.swapfile = false -- Don't create a swapfile
vim.opt.backup = false -- Don't create a backup file
vim.opt.writebackup = false -- Disable backup when writing
vim.opt.termguicolors = true -- Enable true colors in the terminal
vim.opt.fileencoding = "utf-8" -- The encoding written to a file
vim.opt.pumheight = 10 -- Pop up menu height
vim.opt.conceallevel = 0 -- So that `` is visible in markdown files

-- UI and Display
vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true -- Relative numbers
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.wrap = false -- Disable wrap
vim.opt.linebreak = true -- Companion to wrap, don't split words
vim.opt.breakindent = true -- Enable break indent
vim.opt.list = true -- Show listchars
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.showtabline = 2 -- Always show tabs
vim.opt.numberwidth = 4 -- Set number column width

-- Search Options
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Smart case
vim.opt.hlsearch = false -- Don't highlight on search

-- Indentation
vim.opt.autoindent = true -- Copy indent from current line when starting new one
vim.opt.smartindent = true -- Make indenting smarter
vim.opt.shiftwidth = 4 -- The number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- Insert n spaces for a tab
vim.opt.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
vim.opt.expandtab = true -- Convert tabs to spaces

-- Splits
vim.opt.splitright = true -- Force all vertical splits to go to the right of current window
vim.opt.splitbelow = true -- Force all horizontal splits to go below current window

-- Scrolling
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- Minimal number of screen columns either side of cursor if wrap is `false`

-- Timings
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time

-- Completion and Behavior
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.whichwrap = "bs<>[]hl" -- Which "horizontal" keys are allowed to travel to prev/next line
vim.opt.backspace = "indent,eol,start" -- Allow backspace on
vim.opt.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience

-- Clipboard (scheduled to avoid startup performance impact)
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim
end)

-- Shortmess
vim.opt.shortmess:append("c") -- Don't give |ins-completion-menu| messages

-- Keyword and Format Options
vim.opt.iskeyword:append("-") -- Hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Don't insert the current comment leader automatically

-- Runtime Path
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Separate Vim plugins from Neovim in case Vim still in use
