#!/usr/bin/env zsh
# ────────────────────────────────────────────────
# Autor      : leonamsh
# Data       : 2025-09-01
# Descrição  : Configuração simplificada do Zsh com Oh My Zsh, plugins e aliases
# Licença    : Uso pessoal
# Contato    : github.com/leonamsh
# ────────────────────────────────────────────────

# 0) Powerlevel10k instant prompt (deve ficar no topo)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 1) PATHs básicos
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"

# 2) Oh My Zsh + Tema
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"   # usa p10k via oh-my-zsh

# Plugins (ordem importa: syntax-highlighting por último)
plugins=(
  git
  zsh-autosuggestions
  history-substring-search
  zsh-syntax-highlighting
)

# Carrega Oh My Zsh e o tema
source "$ZSH/oh-my-zsh.sh"

# p10k (carrega configuração se existir)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# 3) Autocomplete e histórico
autoload -Uz compinit && compinit -C

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# zsh-autosuggestions: cor discreta
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# 4) Ferramentas/integrações opcionais
# zoxide (cd mais inteligente). Obs: redefine 'cd' para 'z' — comente se não quiser.
eval "$(zoxide init zsh)"
alias cd="z"

# nvm (Node.js)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# 5) Atalhos comuns (agrupados)
# 5.1 — Git
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gitr='git remote set-url origin'
alias clone='git clone'

# 5.2 — Navegação
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cdg='cd ~/.config'
alias cddev='cd /run/media/lm/dev/'

# 5.3 — Neovim / Emacs
export EDITOR=nvim
alias v='nvim'
alias vim='nvim'
# atalhos de edição/configuração
alias nkitty='nvim ~/.config/kitty/kitty.conf'
alias nwez='nvim ~/.config/wezterm/wezterm.lua'
alias nzsh='nvim ~/.zshrc'
alias nfish='nvim ~/.config/fish/config.fish'
# ambientes Neovim
alias nvima='env NVIM_APPNAME=astronvim nvim'
alias nvimc='env NVIM_APPNAME=nvchad nvim'
alias nviml='env NVIM_APPNAME=lazynvim nvim'
# Doom Emacs
alias doomsync='~/.config/emacs/bin/doom sync'
alias doomupd='~/.config/emacs/bin/doom upgrade'
alias doomdoc='~/.config/emacs/bin/doom doctor'
alias doompurge='~/.config/emacs/bin/doom purge'
alias emacs='emacs -nw'

# 5.4 — ls com eza
alias ls='eza -al --color=always --group-directories-first --icons=always'
alias la='eza -a  --color=always --group-directories-first --icons=always'
alias ll='eza -l  --color=always --group-directories-first --icons=always'
alias lt='eza -aT --color=always --group-directories-first --icons=always'
alias l_.="eza -a | grep -e '^\.'"

# 5.5 — Sistema
alias stowa='stow . --adopt'
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# 5.6 — Pessoais 
alias S='sudo pacman -S --noconfirm'
alias Ss='pacman -Ss'
alias pS='paru -S --noconfirm'
alias pSs='paru -Ss'
alias upds='~/.config/autostart/xinputI3.sh'
alias update='/run/media/lm/dev/gitlab/scripts/1-fedora/update.sh'
alias limpao='/run/media/lm/dev/gitlab/scripts/1-fedora/update-clean-arch.sh'
alias srcfish='source ~/.config/fish/config.fish'
alias srczsh='source ~/.zshrc'
alias cdaula='cd /run/media/lm/dev/maisPraTi/'
alias naula='nvim /run/media/lm/dev/maisPraTi/'
alias ninstall='nvim /run/media/lm/dev/gitlab/scripts/1-fedora/post-install.sh'
alias ngit='nvim /run/media/lm/dev/gitlab'

# 6) Funções úteis

# 6.1 — Yazi: retorna para o diretório que você saiu do TUI
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# 7) Keybindings (setas ↑/↓ para buscar no histórico incrementalmente)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Fim.

