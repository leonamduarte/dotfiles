############################################################
# Fish config — Leo (bashln)
# Data: 2025-09-01
# Descrição: Fish + Starship + fzf + zoxide + aliases pessoais
############################################################

## ==========================================================
## 0) Source conf.d do CachyOS (ANTES de tudo)
## ==========================================================
source /usr/share/cachyos-fish-config/conf.d/done.fish


## ==========================================================
## 1) Greeting (fastfetch)
## ==========================================================
function fish_greeting
    fastfetch
end


## ==========================================================
## 2) MAN pages bonitas
## ==========================================================
set -gx MANROFFOPT "-c"
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"


## ==========================================================
## 3) done.fish (notificações)
## ==========================================================
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


## ==========================================================
## 4) Carregar profile compatível com Fish
## ==========================================================
if test -f ~/.fish_profile
    source ~/.fish_profile
end


## ==========================================================
## 5) PATHs
## ==========================================================
set -gx PATH $HOME/.local/bin $HOME/bin /usr/local/bin $HOME/.cargo/bin $PATH
set -gx PATH $PATH /opt/nvim-linux-x86_64/bin

# Linuxbrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# depot_tools (opcional)
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## ==========================================================
## 6) Editor padrão
## ==========================================================
set -gx EDITOR nvim


## ==========================================================
## 7) Starship (prompt)
## ==========================================================
if command -v starship >/dev/null
    starship init fish | source
end


## ==========================================================
## 8) Histórico (Fish já é inteligente, só ajuste fino)
## ==========================================================
set -U fish_history fish
set -U fish_history_max 10000

function history
    builtin history --show-time='%F %T '
end


## ==========================================================
## 9) !! e !$ (bang-bang)
## ==========================================================
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if test "$fish_key_bindings" = fish_vi_key_bindings
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end


## ==========================================================
## 10) zoxide (cd inteligente)
## ==========================================================
if command -v zoxide >/dev/null
    zoxide init fish | source
    alias cd='z'
end


## ==========================================================
## 11) NVM (variável base — recomendado migrar p/ fnm depois)
## ==========================================================
set -gx NVM_DIR $HOME/.nvm


## ==========================================================
## 12) Funções úteis
## ==========================================================

# Backup simples
function backup --argument filename
    cp $filename $filename.bak
end

# Copy inteligente
function copy
    set count (count $argv)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (string trim-right / $argv[1])
        set to $argv[2]
        command cp -r $from $to
    else
        command cp $argv
    end
end

# log: executa comando e salva stdout/stderr em .log
function log
    set cmd $argv
    set base (basename $argv[1])
    set ts (date +%Y%m%d-%H%M%S)
    bash -ic "$cmd" 2>&1 | tee "$base-$ts.log"
end

# yazi com retorno ao diretório
function y
    set tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file=$tmp
    set cwd (string replace -a \0 '' (cat $tmp))
    if test -n "$cwd"; and test "$cwd" != "$PWD"
        cd "$cwd"
    end
    rm -f $tmp
end

# fopen com fzf
function fopen
    set root .
    if test (count $argv) -gt 0
        set root $argv[1]
    end

    fd -t f -H -0 . $root | \
        fzf --read0 --multi --select-1 --exit-0 \
            --bind 'enter:execute-silent(xdg-open {+})+abort' \
            --prompt='files> '
end


## ==========================================================
## 13) Aliases — ls (eza)
## ==========================================================
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a  --color=always --group-directories-first --icons'
alias ll='eza -l  --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"


## ==========================================================
## 14) Aliases — Git
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
## 15) Aliases — Navegação
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
## 16) Aliases — Neovim / Emacs
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

alias nvima='env NVIM_APPNAME=astronvim nvim'
alias nvimc='env NVIM_APPNAME=nvchad nvim'
alias nviml='env NVIM_APPNAME=lazyvim nvim'

alias doomsync='~/.config/emacs/bin/doom sync'
alias doomupd='~/.config/emacs/bin/doom upgrade'
alias doomdoc='~/.config/emacs/bin/doom doctor'
alias doompurge='~/.config/emacs/bin/doom purge'

alias emacs='emacs -nw'
alias demacs='emacs --daemon'
alias kemacs='killall emacs'


## ==========================================================
## 17) Aliases — Sistema / pessoais
## ==========================================================
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"

alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '

alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

alias S='sudo pacman -S --noconfirm'
alias Ss='pacman -Ss'
alias pS='yay -S --noconfirm'
alias pSs='yay -Ss'

alias update='/home/bashln/bashln/bashln-scripts/scripts/update.sh'
alias limpao='sudo /home/bashln/bashln/gitlab/scripts/arch/update-clean.sh'

alias srcfish='source ~/.config/fish/config.fish'
alias srcbash='source ~/.bashrc'
alias srczsh='source ~/.zshrc'

alias cdaula='cd /home/bashln/gitlab/maisPraTi/'
alias naula='nvim /home/bashln/gitlab/maisPraTi/'
alias ninstall='nvim /home/bashln/gitlab/scripts/post-install.sh'
alias ngit='nvim /home/bashln/gitlab'

alias vpninova='sudo openvpn --config /home/bashln/Downloads/sslvpn-itinerario@inova.local-client-config.ovpn --daemon'
alias exithypr='hyprctl dispatch exit'
