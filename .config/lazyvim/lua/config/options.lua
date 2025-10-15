-- Options são carregadas antes do LazyVim: veja os defaults aqui:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Este arquivo apenas complementa/sobrepõe.

local opt = vim.opt
local g = vim.g

-- Líder
g.mapleader = " "

-- ========== UI / Edição ==========
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 10 -- manter “folga” vertical
opt.sidescrolloff = 8

-- Mostrar caracteres invisíveis (útil p/ revisão)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ========== Indentação ==========
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- ========== Busca ==========
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- ========== Desempenho ==========
opt.updatetime = 150
opt.timeoutlen = 400

-- ========== Outros ==========
opt.splitbelow = true
opt.splitright = true

-- ===== LazyVim specifics =====
-- ESLint autoformat (se estiver usando extras linting.eslint)
g.lazyvim_eslint_auto_format = true
-- Toggle global de autoformat no save (do LazyVim); deixe comentado se não quiser mexer.
-- g.autoformat = true

-- Ajustes comentados do Neovide (ativar se usar GUI)
vim.g.neovide_opacity = 0.9
-- vim.g.neovide_scale_factor = 1.0
-- vim.opt.linespace = 3
--

-- Clipboard Wayland robusto (sem travar ao alternar janelas)
local has = function(cmd)
  return vim.fn.executable(cmd) == 1
end

local on_wayland = (vim.env.WAYLAND_DISPLAY and #vim.env.WAYLAND_DISPLAY > 0)

-- Só ativa se estivermos no Wayland e wl-clipboard disponível
if on_wayland and has("wl-copy") and has("wl-paste") then
  -- Se estiver em tmux, habilita o clipboard do tmux para não brigar
  -- (opcional; só faz efeito se você usa tmux)
  if vim.env.TMUX then
    vim.g.tmux_nvim_clipboard = true
  end

  -- Timeout curto no paste evita bloqueios (0.3s)
  local paste_cmd = "timeout 0.3 wl-paste --no-newline 2>/dev/null || true"
  local copy_cmd = "wl-copy --foreground --type text/plain"

  vim.g.clipboard = {
    name = "wl-clipboard (robusto)",
    copy = {
      ["+"] = copy_cmd,
      ["*"] = copy_cmd,
    },
    paste = {
      ["+"] = paste_cmd,
      ["*"] = paste_cmd,
    },
    cache_enabled = 1,
  }
else
  -- Opcional: fallback para XWayland (xclip) se disponível
  if has("xclip") then
    vim.g.clipboard = {
      name = "xclip fallback",
      copy = {
        ["+"] = "xclip -selection clipboard",
        ["*"] = "xclip -selection primary",
      },
      paste = {
        ["+"] = "xclip -o -selection clipboard",
        ["*"] = "xclip -o -selection primary",
      },
      cache_enabled = 1,
    }
  end
end

-- Mantém unnamedplus para usar o provider acima
vim.opt.clipboard = "unnamedplus"
