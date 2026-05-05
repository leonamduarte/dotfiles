# .bashrc
# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc
export PATH=~/.npm-global/bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Android SDK Configuration
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# ------------------------------------------------------------------
# Aliases and helpers (migrated from .zshrc)
# ------------------------------------------------------------------

# Ensure common user paths are early in PATH if they exist
for p in "$HOME/.local/bin" "$HOME/bin" "$HOME/go/bin" "$HOME/.cargo/bin" "/usr/local/bin" "$HOME/.npm-global/bin" "/opt/nvim-linux-x86_64/bin"; do
  if [ -d "$p" ]; then
    PATH="$p:$PATH"
  fi
done

# Editor and common envs
export EDITOR=nvim
export DOOMDIR="$HOME/.config/doom"
export NODE_OPTIONS=--no-deprecation

# Editors
alias v='nvim'
alias vim='nvim'
alias e='emacs'
alias nvima='NVIM_APPNAME=astronvim nvim'
alias bv='NVIM_APPNAME=bash-nvim nvim'
alias nviml='NVIM_APPNAME=lazyvim nvim'
alias nbash='nvim ~/.bashrc'
alias nconf='nvim ~/.bashrc'
alias src='source ~/.bashrc'

# System helpers (mapped from pacman -> toolbox/dnf)
alias update='sudo pacman -Syu --noconfirm'
alias install='sudo pacman -S --needed --noconfirm'
alias search='pacman -Ss'
alias remove='sudo pacman -Rns'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias jctl='journalctl -p 3 -xb'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdg='cd ~/.config'
alias cddev='cd ~/'

# Git shorthands
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias clone='git clone'
alias lz='lazygit'

# Misc
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias dotsize='du -sh .git && git count-objects -vH'
alias cl='clear'
alias ask='gemini'

# Functions
log() {
  local cmd="$*"
  local ts
  ts=$(date +%Y%m%d-%H%M%S)
  eval "$cmd" 2>&1 | tee "$ts.log"
}

cleanup-orphans() {
  toolbox run -c dev sudo dnf autoremove -y
}

doomsync() {
  if [ -x "$HOME/.config/emacs/bin/doom" ]; then
    "$HOME/.config/emacs/bin/doom" sync
  else
    echo "doom not found at $HOME/.config/emacs/bin/doom"
  fi
}

doomupd() {
  if [ -x "$HOME/.config/emacs/bin/doom" ]; then
    "$HOME/.config/emacs/bin/doom" upgrade
  else
    echo "doom not found at $HOME/.config/emacs/bin/doom"
  fi
}

# zoxide (if available)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
fi

# Homebrew (Linux)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

eval "$(starship init bash)"

# ------------------------------------------------------------------
# AI Loop aliases
# ------------------------------------------------------------------
alias ai-bug='bash ~/.config/opencode/scripts/ai-loop.sh once linear-bug-finding'
alias ai-sec='bash ~/.config/opencode/scripts/ai-loop.sh once security-review'
alias ai-deps='bash ~/.config/opencode/scripts/ai-loop.sh once dependency-audit'
alias ai-qa='bash ~/.config/opencode/scripts/ai-loop.sh once qa-review'
alias ai-loop='bash ~/.config/opencode/scripts/ai-loop.sh loop'
alias ai-status='bash ~/.config/opencode/scripts/ai-loop.sh status'
alias ai-dry='DRY_RUN=true bash ~/.config/opencode/scripts/ai-loop.sh once'
alias ai-cron='bash ~/.config/opencode/scripts/ai-loop.sh cron-install'
alias ai-cron-rm='bash ~/.config/opencode/scripts/ai-loop.sh cron-remove'
alias ai-improve='bash ~/.config/opencode/scripts/ai-loop.sh improve'
alias ai-timed='bash ~/.config/opencode/scripts/ai-loop.sh timed'
