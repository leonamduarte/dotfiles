# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# Path to your oh-my-bash installation.
export OSH='/home/bashln/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="powerbash10k"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
# You can also specify the list from which a theme is randomly selected:
# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

# If you want to reduce the initialization cost of the "tput" command to
# initialize color escape sequences, you can uncomment the following setting.
# This disables the use of the "tput" command, and the escape sequences are
# initialized to be the ANSI version:
#
#OMB_TERM_USE_TPUT=no

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"

# 1) PATHs básicos
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 2) Oh My Bash (OMB) + Plugins
export OSH="$HOME/.oh-my-bash"
# O tema do OMB não importa muito porque o Starship vai assumir o prompt,
# mas deixo random pra manter seu estilo divertido.
# OSH_THEME="random"
# OSH_THEME="zork"
# Se quiser restringir, defina candidatos (opcional):
OMB_THEME_RANDOM_CANDIDATES=("agnoster" "powerline-light" "font" "minimal")

# Plugins do OMB (use só os que reabashlnente quer/tem)
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
shopt -s histappend # acrescenta em vez de sobrescrever
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
alias cddev='cd /home/bashln/bashln/'
alias cdprojeto='cd /home/bashln/bashln/projeto-mercado'

# 12) Aliases — Neovim / Emacs
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

# 15) Aliases — Pessoais
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
  cwd="$(tr -d '\0' <"$tmp")"
  if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# 16.3 — fopen: escolher arquivos com fzf e abrir com xdg-open
fopen() {
  local root="${1:-.}"
  fd -t f -H -0 . "$root" |
    fzf --read0 --multi --select-1 --exit-0 \
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

# fnm
FNM_PATH="/home/bashln/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
