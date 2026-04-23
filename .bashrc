############################################################
# Bash config — Leo (bashln)
# Distro: Pop!_OS 24.04 (APT)
# Data: 2025-09-01
# Descrição: Bash + Starship + fzf + aliases pessoais
############################################################

## ==========================================================
## 0) Só para shells interativos
## ==========================================================
case $- in
  *i*) ;;
  *) return ;;
esac

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

# npm global
export PATH="/c/Users/itinerario/.npm-global/bin:$PATH"

## ==========================================================
## 2) Editor padrão
## ==========================================================
export EDITOR=nvim

## ==========================================================
## 3)-history (estilo Fish)
## ==========================================================
HISTFILE=~/.bash_history
HISTSIZE=10000
SAVEHIST=10000

## ==========================================================
## 4) Starship (prompt)
## ==========================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

## ==========================================================
## 5) fzf (bash)
## ==========================================================
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## ==========================================================
## 6) zoxide (cd inteligente)
## ==========================================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
fi

## ==========================================================
## 7)-node.js (fnm)
## ==========================================================
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

## ==========================================================
## 8) Aliases — ls (eza)
## ==========================================================
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a  --color=always --group-directories-first --icons'
alias ll='eza -l  --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"

## ==========================================================
## 9) Aliases — Git
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
## 10) Aliases — Navegação
## ==========================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cdg='cd ~/.config'
alias cddev='cd /home/bashln/bashln/'
alias cdprojeto='cd /home/bashln/bashln/projeto-mercado'

## ==========================================================
## 11) Aliases — Neovim / Emacs
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
alias nprojeto='nvim /home/bashln/gitlab/projeto-mercado/'
alias nsway='nvim ~/.config/sway'
alias nrascunho='nvim ~/Documents/rascunhos/'

# Ambientes Neovim
alias nvima='env NVIM_APPNAME=astronvim nvim'
alias nvimc='env NVIM_APPNAME=nvchad nvim'
alias nviml='env NVIM_APPNAME=lazyvim nvim'

# Doom Emacs
alias doomsync='~/.config/emacs/bin/doom sync'
alias doomupd='~/.config/emacs/bin/doom upgrade'
alias doomdoc='~/.config/emacs/bin/doom doctor'
alias doompurge='~/.config/emacs/bin/doom purge'
alias emacs='emacs -nw'
alias demacs='emacs --daemon'
alias kemacs='killall emacs'

## ==========================================================
## 12) Aliases — Sistema (APT)
## ==========================================================
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove -y'
alias search='apt search'

alias stowa='stow -t ~ --adopt dotfiles'
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

## ==========================================================
## 13) Aliases — Pessoais
## ==========================================================
alias S='sudo pacman -S --noconfirm'
alias Ss='pacman -Ss'
alias pS='yay -S --noconfirm'
alias pSs='yay -Ss'
alias upds='~/.config/autostart/xinputI3.sh'
alias update='/home/bashln/bashln/bashln-scripts/scripts/update.sh'
alias limpao='sudo /home/bashln/bashln/gitlab/scripts/arch/update-clean.sh'
alias srcfish='source ~/.config/fish/config.fish'
alias srczsh='source ~/.zshrc'
alias srcbash='source ~/.bashrc'
alias cdaula='cd /home/bashln/gitlab/maisPraTi/'
alias naula='nvim /home/bashln/gitlab/maisPraTi/'
alias ninstall='nvim /home/bashln/gitlab/scripts/post-install.sh'
alias ngit='nvim /home/bashln/gitlab'
alias vpninova='sudo openvpn --config /home/bashln/Downloads/sslvpn-itinerario@inova.local-client-config.ovpn --daemon'
alias exithypr='hyprctl dispatch exit'

## ==========================================================
## 14) Funções
## ==========================================================

# log: executa comando, salva stdout/stderr e cria .log
log() {
  local cmd="$*"
  local base="${1##*/}"
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  bash -ic "$cmd" 2>&1 | tee "${base}-${ts}.log"
}

# yazi: volta pro diretório onde você saiu do TUI
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  # yazi grava NUL; removemos NUL pra obter caminho limpo
  cwd="$(tr -d '\0' <"$tmp")"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# fopen: escolher arquivos com fzf e abrir com xdg-open
fopen() {
  local root="${1:-.}"
  fd -t f -H -0 . "$root" |
    fzf --read0 --multi --select-1 --exit-0 \
      --bind 'enter:execute-silent(xdg-open {+})+abort' \
      --prompt='files> '
}

# fnm
FNM_PATH="/home/bashln/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
fi
