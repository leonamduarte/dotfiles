source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
    # smth smth
end

# ─────────────────────────────────────────────────────────────────────────────
# Autor      : leonamsh
# Data       : 2025-09-01 (convertido p/ fish: funções nativas)
# Descrição  : Config do Fish com equivalentes do seu .zshrc (sem 'alias')
# ─────────────────────────────────────────────────────────────────────────────

# 0) Prompt/tema (p10k é do Zsh)
# Sugestões:
#  - tide:     fisher install IlanCosman/tide@v6
#  - starship: starship init fish | source

# 1) PATHs
fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path /usr/local/bin
fish_add_path ~/.cargo/bin
fish_add_path /opt/nvim-linux-x86_64/bin

# 2) Variáveis
set -gx EDITOR nvim
set -gx ZSH ~/.oh-my-zsh
set -g fish_color_autosuggestion brblack # aproxima 'fg=8'

# 3) Integrações

# 3.1 zoxide (cd inteligente)
if type -q zoxide
    zoxide init fish | source
    # replicar "alias cd='z'": reimplementa cd
    function cd --description 'zoxide as default cd'
        if type -q z
            z $argv
        else
            builtin cd $argv
        end
    end
end

# 3.2 Node (nvm no fish)
# Recomendo: fnm (nativo) ou nvm.fish (via fisher).
if type -q fnm
    fnm env --use-on-cd | source
end

# 4) Histórico/completion
# Fish já faz case-insensitive e tem completion robusto por padrão.

# 5) Funções equivalentes aos seus aliases

# 5.1 — Git
function gs
    command git status $argv
end
function ga
    command git add -A $argv
end
function gc
    command git commit -m $argv
end
function gp
    command git push $argv
end
function gl
    command git pull $argv
end
function gco
    command git checkout $argv
end
function gitr
    command git remote set-url origin $argv
end
function clone
    command git clone $argv
end
function lz
    command lazygit $argv
end

# 5.2 — Navegação
function ..
    builtin cd ..
end
function ...
    builtin cd ../..
end
function ....
    builtin cd ../../..
end
function .....
    builtin cd ../../../..
end
function ......
    builtin cd ../../../../..
end
function cdg
    builtin cd ~/.config
end
function cddev
    builtin cd /home/lm/leonamsh/
end
function cdprojeto
    builtin cd /home/lm/leonamsh/projeto-mercado
end

# 5.3 — Neovim / Emacs
function v
    command nvim $argv
end
function vim
    command nvim $argv
end
function nkitty
    command nvim ~/.config/kitty/kitty.conf
end
function nwez
    command nvim ~/.config/wezterm/wezterm.lua
end
function nalac
    command nvim ~/.config/alacritty/alacritty.toml
end
function nzsh
    command nvim ~/.zshrc
end
function nfish
    command nvim ~/.config/fish/config.fish
end
function nprojeto
    command nvim /home/lm/leonamsh/projeto-mercado/
end
function nsway
    command nvim ~/.config/sway
end
function nrascunho
    command nvim ~/Documents/rascunhos/
end

# ambientes Neovim
function nvima
    env NVIM_APPNAME=astronvim nvim $argv
end
function nvimc
    env NVIM_APPNAME=nvchad nvim $argv
end
function nviml
    env NVIM_APPNAME=lazyvim nvim $argv
end

# Doom Emacs
function doomsync
    ~/.config/emacs/bin/doom sync
end
function doomupd
    ~/.config/emacs/bin/doom upgrade
end
function doomdoc
    ~/.config/emacs/bin/doom doctor
end
function doompurge
    ~/.config/emacs/bin/doom purge
end
function emacs
    command emacs -nw $argv
end
function demacs
    command emacs --daemon $argv
end
function kemacs
    command killall emacs
end

# 5.4 — eza/ls
function ls
    command eza -al --color=always --group-directories-first --icons=always $argv
end
function la
    command eza -a --color=always --group-directories-first --icons=always $argv
end
function ll
    command eza -l --color=always --group-directories-first --icons=always $argv
end
function lt
    command eza -aT --color=always --group-directories-first --icons=always $argv
end
function l_.
    command eza -a | grep -e '^\.'
end

# 5.5 — Sistema
function stowa
    command stow . --adopt $argv
end
function grubup
    command sudo grub-mkconfig -o /boot/grub/grub.cfg
end
function fixpacman
    command sudo rm /var/lib/pacman/db.lck
end
function tarnow
    command tar -acf $argv
end
function untar
    command tar -zxvf $argv
end
function wget
    command wget -c $argv
end
function psmem
    command ps auxf | sort -nr -k 4
end
function psmem10
    command ps auxf | sort -nr -k 4 | head -10
end
function jctl
    command journalctl -p 3 -xb
end
function rip
    command expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl
end

# 5.6 — Pessoais
# dnf5 variações comentadas no original
function S
    command sudo pacman -S --noconfirm $argv
end
function Ss
    command pacman -Ss $argv
end
function pS
    command paru -S --noconfirm $argv
end
function pSs
    command paru -Ss $argv
end
function upds
    ~/.config/autostart/xinputI3.sh $argv
end
function update
    command /home/lm/scripts/update.sh $argv
end
function limpao
    command sudo /home/lm/scripts/update-clean.sh $argv
end
function srcfish
    source ~/.config/fish/config.fish
end
function srczsh
    source ~/.zshrc
end
function cdaula
    builtin cd /home/lm/leonamsh/maisPraTi/
end
function naula
    command nvim /home/lm/leonamsh/maisPraTi/
end
function ninstall
    command nvim /home/lm/scripts/post-install.sh
end
function ngit
    command nvim /home/lm/leonamsh/gitlab
end
function vpninova
    command sudo openvpn --config /home/lm/Downloads/sslvpn-itinerario@inova.local-client-config.ovpn $argv
end

# 6) Funções utilitárias do seu .zshrc

# 6.1 — log: executa comando e salva saída em arquivo .log
functions -e log 2>/dev/null
function log --description 'Run a command and tee output to <base>-<ts>.log'
    set cmd $argv
    if test (count $cmd) -eq 0
        echo "uso: log <comando ...>"
        return 2
    end
    set base (basename -- $argv[1])
    set ts (date +%Y%m%d-%H%M%S)
    fish -ic "$cmd" 2>&1 | tee "$base-$ts.log"
end

# 6.2 — yazi: retorna ao diretório escolhido
function y --description 'Open yazi and cd into its last cwd'
    set tmp (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file="$tmp"
    if test -f "$tmp"
        set cwd (string collect < "$tmp")
        if test -n "$cwd"; and test "$cwd" != (pwd)
            cd "$cwd"
        end
        rm -f "$tmp"
    end
end

# 6.3 — fopen: abrir arquivos via fd+fzf usando xdg-open
function fopen --description 'Pick files with fd+fzf and open with xdg-open'
    set root "."
    if test (count $argv) -ge 1
        set root $argv[1]
    end
    fd -t f -H -0 . "$root" \
        | fzf --read0 --multi --select-1 --exit-0 \
        --bind 'enter:execute-silent(xdg-open {+})+abort' \
        --prompt='files> '
end

# 7) Keybindings (history search em ↑/↓ por prefixo)
bind \e\[A history-search-backward
bind \e\[B history-search-forward

# ─────────────────────────────────────────────────────────────────────────────
# Fim
