source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Variáveis de ambiente
set -gx ZSH "$HOME/.oh-my-zsh"

set -g fish_greeting ""

# Adicionar caminhos ao PATH [cite: 8, 9]
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/bin"
fish_add_path /usr/local/bin
fish_add_path "$HOME/.cargo/bin"

# Editor para a função y
set -gx EDITOR nvim

# ------------------------------
# ALIASES PRÁTICOS [cite: 5, 6, 8, 9, 10, 11]
# ------------------------------
function ll
    ls -lah $argv
end

function la
    ls -A $argv
end

function gs
    git status $argv
end

function gp
    git push $argv
end

function gl
    git pull $argv
end

function y
    yazi $argv
end

# ------------------------------
# Atualizações [cite: 7, 8]
# ------------------------------
function S
    sudo pacman -S --noconfirm --needed $argv
end

function pS
    paru -S --noconfirm --needed $argv
end

function Ss
    pacman -Ss $argv
end

function pSs
    paru -Ss $argv
end

function dins
    sudo dnf install -y $argv
end

function dsrc
    dnf search $argv
end

function fsrc
    flatpak search $argv
end

function fins
    flatpak install -y $argv
end

function upds
    ~/.config/autostart/xinputI3.sh $argv
end

function update
    /run/media/lm/dev/gitlab/scripts/1-arch/update.sh $argv
end

function limpao
    /run/media/lm/dev/gitlab/scripts/1-arch/update-clean-arch.sh $argv
end

function cdg
    cd .config $argv
end

function srcfish
    source ~/.config/fish/config.fish $argv
end

function srczsh
    source ~/.zshrc $argv
end

function clone
    git clone $argv
end

function cddev
    cd /run/media/lm/dev/ $argv
end

function gitr
    git remote set-url origin $argv
end

function npostinstall
    v /run/media/lm/dev/gitlab/scripts/1-arch/post-install.sh $argv
end

function cdpostinstall
    cd /run/media/lm/dev/gitlab/scripts/1-arch/post-install.sh $argv
end
# ------------------------------
# Aliases do Doom [cite: 7]
# ------------------------------
function doomsync
    ~/.config/emacs/bin/doom sync $argv
end

function doomupd
    ~/.config/emacs/bin/doom upgrade $argv
end

function doomdoc
    ~/.config/emacs/bin/doom doctor $argv
end

function doompurge
    ~/.config/emacs/bin/doom purge $argv
end

function dinstall
    emacs -nw /run/media/lm/dev/gitlab/scripts/1-fedora/post-install.sh $argv
end

function emacs
    emacs -nw $argv
end

# ------------------------------
# Aliases de mudança de diretório [cite: 7, 8]
# ------------------------------
function cdaula
    cd /run/media/lm/dev/maisPraTi/ $argv
end

function naula
    nvim /run/media/lm/dev/maisPraTi/ $argv
end

function cdprojeto
    cd /run/media/lm/dev/projeto-mercado-frontend/
end

function nprojeto
    nvim /run/media/lm/dev/projeto-mercado-frontend/
end

# ------------------------------
# Aliases do Nvim 
# ------------------------------
function v
    nvim $argv
end

function nl
    nviml $argv
end

function vim
    nvim $argv
end

function nkitty
    nvim ~/.config/kitty/kitty.conf $argv
end

function nalac
    nvim ~/.config/alacritty/alacritty.toml $argv
end

function nwez
    nvim ~/.config/wezterm/wezterm.lua $argv
end

function ngtty
    nvim ~/.config/ghostty/config $argv
end

function nfish
    nvim ~/.config/fish/config.fish $argv
end

function nhypr
    nvim ~/.config/hypr/config/keybinds.conf $argv
end

function nqtile
    nvim ~/.config/qtile/config.py $argv
end

function ni3
    nvim ~/.config/i3/config $argv
end

function nsway
    nvim ~/.config/sway/config $argv
end

function nzsh
    nvim ~/.zshrc $argv
end

function ninstall
    nvim /run/media/lm/dev/gitlab/scripts/1-fedora/post-install.sh $argv
end

function ngit
    nvim /run/media/lm/dev/gitlab $argv
end

function nvimz
    env NVIM_APPNAME=nvim-lazar nvim $argv
end

function nl
    env NVIM_APPNAME=lazyvim nvim $argv
end

function vk
    env NVIM_APPNAME=nvim-kickstart nvim $argv
end

# ------------------------------
# Outros aliases [cite: 8, 9, 10, 11]
# ------------------------------
function stowa
    stow . --adopt $argv
end

function grubup
    sudo grub-mkconfig -o /boot/grub/grub.cfg $argv
end

function fixpacman
    sudo rm /var/lib/pacman/db.lck $argv
end

function tarnow
    tar -acf $argv
end

function untar
    tar -zxvf $argv
end

function wget
    wget -c $argv
end

function psmem
    ps auxf | sort -nr -k 4 $argv
end

function psmem10
    ps auxf | sort -nr -k 4 | head -10 $argv
end

function ..
    cd .. $argv
end

function ...
    cd ../.. $argv
end

function ....
    cd ../../.. $argv
end

function .....
    cd ../../../.. $argv
end

function ......
    cd ../../../../.. $argv
end

# function dir
#     dir --color=auto $argv
# end
#
# function vdir
#     vdir --color=auto $argv
# end
#
# function grep
#     grep --color=auto $argv
# end
#
# function fgrep
#     fgrep --color=auto $argv
# end
#
# function egrep
#     egrep --color=auto $argv
# end
#
# function hw
#     hwinfo --short $argv
# end
#
# function big
#     expac -H M '%m\t%n' | sort -h | nl $argv
# end
#
# function gitpkg
#     pacman -Q | grep -i "\-git" | wc -l $argv
# end
#
# function jctl
#     journalctl -p 3 -xb $argv
# end
#
# function rip
#     expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl $argv
# end

# ------------------------------
# Função toggle-theme [cite: 5]
# ------------------------------
function toggle-theme
    set current_theme (awk '$1=="include" {print $2}' "$HOME/.config/kitty/kitty.conf")
    set new_theme "rose-pine.conf"

    if test "$current_theme" = "rose-pine.conf"
        set new_theme "rose-pine-dawn.conf"
    end

    # Define o tema para sessões ativas
    kitty @ set-colors --all --configured "~/.config/kitty/$new_theme"

    # Atualiza a configuração para persistência
    # Usa 'sed -i' com um backup para compatibilidade (BSD ou GNU)
    sed -i .bak "s/include.*/include $new_theme/" "$HOME/.config/kitty/kitty.conf"
end

# ------------------------------
# Função yazi (y) [cite: 11]
# ------------------------------
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if test -s "$tmp"
        set cwd (cat "$tmp")
    end
    if test -n "$cwd"
        if test "$cwd" != "$PWD"
            cd -- "$cwd"
        end
    end
    rm -f -- "$tmp"
end
