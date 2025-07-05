# source /usr/share/cachyos-fish-config/cachyos-config.fish
#
# # overwrite greeting
# # potentially disabling fastfetch
# #function fish_greeting
# #    # smth smth
# #end
#

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

## Source from conf.d before our fish config

## Set values
function fish_greeting
    colorscript random
end
set -g theme_svn_prompt_enabled yes
# Format man pages
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

# Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
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

if [ "$fish_key_bindings" = fish_vi_key_bindings ]

    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

function full_history
    history | fzf --no-sort | read -l command
    and commandline $command
end

# study stream aliases (Fish shell version)
# shell /usr/bin/fish
# Requer https://github.com/caarlos0/timer e o comando spd-say

function cleanup_pomodoro --on-signal INT
    if set -q music_pid
        kill $music_pid 2>/dev/null
    end
    echo -e "\n🛑 Sessão interrompida." | lolcat
end

function pomodoro
    if test (count $argv) -eq 0
        echo "Uso: pomodoro [trabalho|descanso]"
        return 1
    end

    set -g music_pid "" # precisa ser global pra trap conseguir acessar
    set -l pomo_type $argv[1]
    set -l duration ""
    set -l music_url "https://www.youtube.com/watch?v=jfKfPfyJRdk"

    switch $pomo_type
        case trabalho
            set duration 45
        case descanso
            set duration 5
        case '*'
            echo "Tipo inválido: $pomo_type"
            return 1
    end
    echo "Iniciando sessão: $pomo_type por $duration minutos" | lolcat
    timer {$duration}m

    #echo "🎧 Iniciando sessão: $pomo_type por $duration minutos" | lolcat
    #if test -n "$music_url"
    #    mpv --quiet --no-video --volume=100 $music_url >/dev/null 2>&1 &
    #    set -g music_pid $last_pid
    #end

    # Encerra a música quando o timer termina normalmente
    #if set -q music_pid
    #    kill $music_pid 2>/dev/null
    #end

    #spd-say "sessão de '$pomo_type' finalizada"

    #if type -q notify-send
    #    notify-send "⏰ Pomodoro finalizado!" "Sessão '$pomo_type' de $duration minutos terminou."
    #end
end

alias wo='pomodoro trabalho'
alias br='pomodoro descanso'

set -gx PATH ~/.npm-global/bin $PATH

function cleanup --description "Remove orphaned packages"
    set ORPHANS (pacman -Qdtq)
    if test -n "$ORPHANS"
        echo "Removing: $ORPHANS"
        sudo pacman -Rs $ORPHANS
    else
        echo "No orphaned packages to remove."
    end
end

## Useful aliases
#Leonam
###############################################
# updates #####################################
###############################################
alias S='sudo pacman -S --noconfirm --needed'
alias Ss='sudo pacman -Ss'
alias upds='~/.config/autostart/xinputI3.sh'
alias update='/run/media/development/scripts/arch/full-update.sh'
alias limpao='/run/media/development/scripts/arch/update-clean-arch.sh'
alias cdg='cd .config'
alias srcfish='source ~/.config/fish/config.fish'
alias srczsh='source ~/.zshrc'
alias clone='git clone'
alias cddev='cd /run/media/development/'
###############################################
# doom aliases ################################
###############################################
alias doomsync='~/.config/emacs/bin/doom sync'
alias doomupd='~/.config/emacs/bin/doom upgrade'
alias doomdoc='~/.config/emacs/bin/doom doctor'
alias doompurge='~/.config/emacs/bin/doom purge'
alias dinstall='emacs -nw /run/media/development/scripts/arch/post-install.sh'
alias emacs='emacs -nw'
###############################################
# change directory aliases ####################
###############################################
alias cdaula='cd /run/media/development/maisPraTi/'
alias naula='neovide /run/media/development/maisPraTi/'
###############################################
# neovide aliases#################################
###############################################
alias nkitty='neovide ~/.config/kitty/kitty.conf'
alias nalac='neovide ~/.config/alacritty/alacritty.toml'
alias nfish='neovide ~/.config/fish/config.fish'
alias nqtile='neovide ~/.config/qtile/config.py'
alias nzsh='neovide ~/.zshrc'
alias ninstall='neovide /run/media/development/scripts/arch/post-install.sh'
alias neovidea="env NVIM_APPNAME=astronvim nvim"
alias neovidec="env NVIM_APPNAME=nvchad nvim"
alias neovidel="env NVIM_APPNAME=lazynvim nvim"
###############################################
# other aliases ###############################
###############################################
# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles

# Common use
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl" # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Cleanup orphaned packages
# alias cleanup='sudo pacman -Rs $(sudo pacman -Qdtq)'
# alias cleanup='ORPHANS=$(sudo pacman -Qdtq); if [ -n "$ORPHANS" ]; then sudo pacman -Rs $ORPHANS; else echo "No orphaned packages to remove."; fi'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
