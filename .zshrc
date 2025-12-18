############################################################
# Zsh config — Leo (bashln)
# Distro: Pop!_OS 24.04 (APT)
# Data: 2025-09-01
# Descrição: Zsh + Starship + fzf + zoxide + aliases pessoais
############################################################

## ==========================================================
## 0) Só para shells interativos
## ==========================================================
[[ -o interactive ]] || return


## ==========================================================
## 1) PATHs
## ==========================================================
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"

# Neovim manual (se existir)
[ -d /opt/nvim-linux-x86_64/bin ] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Linuxbrew
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


## ==========================================================
## 2) Editor padrão
## ==========================================================
export EDITOR=nvim


## ==========================================================
## 3) História (estilo Fish)
## ==========================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY


## ==========================================================
## 4) Completion moderna
## ==========================================================
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Menu interativo
zstyle ':completion:*' menu select


## ==========================================================
## 5) Starship (prompt)
## ==========================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi


## ==========================================================
## 6) fzf (APT-friendly)
## ==========================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


## ==========================================================
## 7) zoxide (cd inteligente)
## ==========================================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi


## ==========================================================
## Node.js (fnm)
## ==========================================================
export FNM_PATH="$HOME/.local/share/fnm"
export PATH="$FNM_PATH:$PATH"
eval "$(fnm env)"


## ==========================================================
## 9) Keybinds úteis
## ==========================================================
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search


## ==========================================================
## 10) Aliases — ls (eza)
## ==========================================================
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a  --color=always --group-directories-first --icons'
alias ll='eza -l  --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep -e "^\."' 


## ==========================================================
## 11) Aliases — Git
## ==========================================================
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gitr='git remote set-url origin'
alias clone='git clone'
alias lz='lazygit'


## ==========================================================
## 12) Aliases — Navegação
## ==========================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias cdg='cd ~/.config'
alias cddev='cd ~/bashln/'
alias cdprojeto='cd ~/bashln/projeto-mercado'


## ==========================================================
## 13) Aliases — Neovim / Emacs
## ==========================================================
alias v='nvim'
alias vim='nvim'

alias nkitty='nvim ~/.config/kitty/kitty.conf'
alias nwez='nvim ~/.config/wezterm/wezterm.lua'
alias nmacs='nvim ~/.config/emacs/'
alias nalac='nvim ~/.config/alacritty/alacritty.toml'
alias nghost='nvim ~/.config/ghostty/config'
alias nzsh='nvim ~/.zshrc'
alias nbash='nvim ~/.bashrc'
alias nfish='nvim ~/.config/fish/config.fish'

alias nprojeto='nvim ~/gitlab/projeto-mercado/'
alias nsway='nvim ~/.config/sway'
alias nrascunho='nvim ~/Documents/rascunhos/'

# Ambientes Neovim
alias nvima='NVIM_APPNAME=astronvim nvim'
alias nvimc='NVIM_APPNAME=nvchad nvim'
alias nviml='NVIM_APPNAME=lazyvim nvim'

# Doom Emacs
alias doomsync='~/.config/emacs/bin/doom sync'
alias doomupd='~/.config/emacs/bin/doom upgrade'
alias doomdoc='~/.config/emacs/bin/doom doctor'
alias doompurge='~/.config/emacs/bin/doom purge'

alias emacs='emacs -nw'
alias demacs='emacs --daemon'
alias kemacs='killall emacs'


## ==========================================================
## 14) Aliases — Sistema (APT)
## ==========================================================
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove -y'
alias search='apt search'

alias jctl='journalctl -p 3 -xb'
alias wget='wget -c'
alias tarnow='tar -acf '
alias untar='tar -zxvf '


## ==========================================================
## 15) Aliases — Pessoais
## ==========================================================
alias srczsh='source ~/.zshrc'
alias srcfish='source ~/.config/fish/config.fish'

alias cdaula='cd ~/gitlab/maisPraTi/'
alias naula='nvim ~/gitlab/maisPraTi/'
alias ninstall='nvim ~/gitlab/scripts/post-install.sh'
alias ngit='nvim ~/gitlab'

alias vpninova='sudo openvpn --config ~/Downloads/sslvpn-itinerario@inova.local-client-config.ovpn --daemon'
alias exithypr='hyprctl dispatch exit'


## ==========================================================
## 16) Funções
## ==========================================================

# log: executa comando e salva stdout/stderr
log() {
  local cmd="$*"
  local base="${1##*/}"
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  zsh -ic "$cmd" 2>&1 | tee "${base}-${ts}.log"
}

# yazi com retorno de diretório
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(tr -d '\0' <"$tmp")"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
  rm -f -- "$tmp"
}

# fopen com fzf + xdg-open
fopen() {
  local root="${1:-.}"
  fd -t f -H -0 . "$root" |
    fzf --read0 --multi --select-1 --exit-0 \
      --bind 'enter:execute-silent(xdg-open {+})+abort' \
      --prompt='files> '
}

## ==========================================================
## 17) sources
## ==========================================================

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

