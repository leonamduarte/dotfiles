

# ~/.bashrc — Oh My Bash + Starship (Leo)
# Autor: leonamsh | Data: 2025-09-01 (convertido p/ bash)
# Descrição: Config simplificada em Bash com OMB + Starship + seus aliases/funções

# 0) Só continue se for sessão interativa
case $- in
  *i*) ;;
  *) return ;;
esac

# 1) PATHs básicos
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


# 2) Oh My Bash (OMB) + Plugins
export OSH="$HOME/.oh-my-bash"
# O tema do OMB não importa muito porque o Starship vai assumir o prompt,
# mas deixo random pra manter seu estilo divertido.
OSH_THEME="random"
# Se quiser restringir, defina candidatos (opcional):
# OMB_THEME_RANDOM_CANDIDATES=("agnoster" "powerline-light" "font" "minimal")

# Plugins do OMB (use só os que realmente quer/tem)
# Obs: "zsh-autosuggestions" e "zsh-syntax-highlighting" não existem em bash.
# Sugestão: usar fzf + bash-completion + zoxide.
plugins=(
  git
)

# Carrega Oh My Bash
if [ -s "$OSH/oh-my-bash.sh" ]; then
  source "$OSH/oh-my-bash.sh"
fi

# 3) Starship (prompt)
# Requer starship instalado. Se tiver um starship.toml custom, export STARSHIP_CONFIG.
# export STARSHIP_CONFIG="$HOME/.config/starship.toml"
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# 4) Bash completion (auto-complete inteligente)
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# 5) FZF (bash)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# 6) Histórico e comportamento (equivalente ao setopt do Zsh)
export HISTFILE=~/.bash_history
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend                 # acrescenta em vez de sobrescrever
# Salva cmd recém executado no histórico e atualiza entre sessões
PROMPT_COMMAND='history -a; history -c; history -r; '"$PROMPT_COMMAND"

# Case-insensitive completion
# (faz o Tab ignorar caixa-alta/baixa)
bind "set completion-ignore-case on"

# Setas ↑/↓ buscam no histórico por prefixo (estilo incremental)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# 7) zoxide (cd mais inteligente)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
fi

# 8) NVM (Node.js)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# 9) Editor padrão
export EDITOR=nvim

# 10) Aliases — Git
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gitr='git remote set-url origin'
alias clone='git clone'
alias lz='lazygit'

# 11) Aliases — Navegação
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cdg='cd ~/.config'
alias cddev='cd /home/lm/leonamsh/'
alias cdprojeto='cd /home/lm/leonamsh/projeto-mercado'

# 12) Aliases — Neovim / Emacs
alias v='nvim'
alias vim='nvim'
alias nkitty='nvim ~/.config/kitty/kitty.conf'
alias nwez='nvim ~/.config/wezterm/wezterm.lua'
alias nalac='nvim ~/.config/alacritty/alacritty.toml'
alias nghost='nvim ~/.config/ghostty/config'
alias nzsh='nvim ~/.zshrc'
alias nbash='nvim ~/.bashrc'
alias nfish='nvim ~/.config/fish/config.fish'
alias nprojeto='nvim /home/lm/leonamsh/projeto-mercado/'
alias nsway='nvim ~/.config/sway'
alias nrascunho='nvim ~/Documents/rascunhos/'
# ambientes Neovim
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

# 13) Aliases — ls com eza
alias ls='eza -al --color=always --group-directories-first --icons=always'
alias la='eza -a  --color=always --group-directories-first --icons=always'
alias ll='eza -l  --color=always --group-directories-first --icons=always'
alias lt='eza -aT --color=always --group-directories-first --icons=always'
alias l_.="eza -a | grep -e '^\.'"

# 14) Aliases — Sistema
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

# 15) Aliases — Pessoais
alias S='sudo pacman -S --noconfirm'
alias Ss='pacman -Ss'
alias pS='yay -S --noconfirm'
alias pSs='yay -Ss'
alias upds='~/.config/autostart/xinputI3.sh'
alias update='/home/lm/dotfiles/bashln/update.sh'
alias limpao='sudo /home/lm/dotfiles/scripts/update-clean.sh'
alias srcfish='source ~/.config/fish/config.fish'
alias srczsh='source ~/.zshrc'
alias srcbash='source ~/.bashrc'
alias cdaula='cd /home/lm/leonamsh/maisPraTi/'
alias naula='nvim /home/lm/leonamsh/maisPraTi/'
alias ninstall='nvim /home/lm/scripts/post-install.sh'
alias ngit='nvim /home/lm/leonamsh/gitlab'
alias vpninova='sudo openvpn --config /home/lm/Downloads/sslvpn-itinerario@inova.local-client-config.ovpn'

# 16) Funções

# 16.1 — log: executa comando, salva stdout/stderr e cria .log
# Em zsh você usava "zsh -ic" pra expandir aliases; aqui usamos "bash -ic".
log() {
  local cmd="$*"
  local base="${1##*/}"
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  bash -ic "$cmd" 2>&1 | tee "${base}-${ts}.log"
}

# 16.2 — yazi: volta pro diretório onde você saiu do TUI
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  # yazi grava NUL; removemos NUL pra obter caminho limpo
  cwd="$(tr -d '\0' < "$tmp")"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# 16.3 — fopen: escolher arquivos com fzf e abrir com xdg-open
fopen() {
  local root="${1:-.}"
  fd -t f -H -0 . "$root" \
  | fzf --read0 --multi --select-1 --exit-0 \
        --bind 'enter:execute-silent(xdg-open {+})+abort' \
        --prompt='files> '
}

# 17) Qualquer coisa que era específica do Zsh e não faça sentido no Bash foi removida:
# - compinit / zstyle matcher
# - p10k / instant prompt
# - plugins exclusivos do zsh (autosuggestions, syntax-highlighting)
# Se quiser "autosuggestions" no Bash, avalie:
#   https://github.com/marlonrichert/bash-autocomplete (autocomplete) ou
#   https://github.com/arzzen/calc.plugin.bash (exemplo de plugin OMB)
#   fzf já cobre boa parte do fluxo.


