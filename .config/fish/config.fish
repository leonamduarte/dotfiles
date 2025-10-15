source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
# ===== Helpers & "aliases como funções" (Fish) =====
# Não usa 'alias', só 'function', como você pediu.

# ----- Listar (usa eza se existir) -----
function l --description "ls compacto (usa eza se disponível)"
    if type -q eza
        command eza --group-directories-first $argv
    else
        command ls -CF $argv
    end
end

function ll --description "ls detalhado (usa eza se disponível)"
    if type -q eza
        command eza -lah --group-directories-first --icons $argv
    else
        command ls -lah $argv
    end
end

function la --description "lista incluindo ocultos (usa eza se disponível)"
    if type -q eza
        command eza -a --icons $argv
    else
        command ls -A $argv
    end
end

# ----- cat/grep/ip com melhorias, mas sem quebrar se não houver bat -----
function cat --description "cat com bat se disponível"
    if type -q bat
        command bat $argv
    else
        command cat $argv
    end
end

function grep --description "grep com cor se suportado"
    command grep --color=auto $argv
end

function ip --description "ip com cor se suportado"
    command ip -c $argv
end

# ----- Git rápido -----
function gst --description "git status curto"
    command git status -sb $argv
end

function gco --description "git checkout ..."
    command git checkout $argv
end

function gcm --description "git checkout main"
    command git checkout main
end

function gcd --description "git checkout develop"
    command git checkout develop
end

function gl --description "git pull --rebase"
    command git pull --rebase $argv
end

function gpl --description "git pull"
    command git pull $argv
end

function gp --description "git push"
    command git push $argv
end

function gps --description "git push (atalho)"
    command git push $argv
end

function gcb --description "git checkout -b <branch>"
    test (count $argv) -ge 1; or begin
        echo "uso: gcb <nova-branch>"
        return 1
    end
    command git checkout -b $argv
end

function gfa --description "git fetch --all --prune"
    command git fetch --all --prune $argv
end

function gds --description "git diff --staged"
    command git diff --staged $argv
end

function gdl --description "git describe curto"
    command git describe --tags --always $argv
end

function gclean --description "apaga branches locais já mescladas (exceto main/develop)"
    set branches (command git branch --merged | string trim)
    for b in $branches
        switch $b
            case "*"
                # pula a branch atual (marcada com *)
                continue
            case main develop
                continue
            case ""
                continue
            case "*"
                command git branch -d $b
        end
    end
end

# ----- Docker/Podman (auto-detecta) -----
function __ctr_bin
    if type -q docker
        echo docker
    else if type -q podman
        echo podman
    else
        echo "" # nenhum disponível
    end
end

function d --description "docker/podman pass-through"
    set bin (__ctr_bin)
    test -n "$bin"; or begin
        echo "Nenhum container engine encontrado (docker/podman)."
        return 127
    end
    command $bin $argv
end

function dps --description "containers em execução"
    set bin (__ctr_bin)
    test -n "$bin"; or return 127
    command $bin ps $argv
end

function di --description "imagens locais"
    set bin (__ctr_bin)
    test -n "$bin"; or return 127
    command $bin images $argv
end

function dcu --description "compose up -d"
    set bin (__ctr_bin)
    test -n "$bin"; or return 127
    command $bin compose up -d $argv
end

function dcd --description "compose down"
    set bin (__ctr_bin)
    test -n "$bin"; or return 127
    command $bin compose down $argv
end

function drm --description "remove container(s)"
    set bin (__ctr_bin)
    test -n "$bin"; or return 127
    command $bin rm -f $argv
end

function drmi --description "remove image(s)"
    set bin (__ctr_bin)
    test -n "$bin"; or return 127
    command $bin rmi $argv
end

# ----- Gerenciador de pacotes (DNF/Pacman/APT) -----
function __pkg_kind
    if type -q dnf
        echo dnf
    else if type -q pacman
        echo pacman
    else if type -q apt
        echo apt
    else
        echo none
    end
end

function up --description "atualiza sistema (e Flatpak, se houver)"
    switch (__pkg_kind)
        case dnf
            sudo dnf upgrade --refresh -y; and flatpak update -y
        case pacman
            sudo pacman -Syu --noconfirm; and flatpak update -y
        case apt
            sudo apt update; and sudo apt full-upgrade -y; and flatpak update -y
        case none
            echo "Nenhum gerenciador de pacotes comum encontrado."
            return 127
    end
end

function in --description "instalar pacote(s)"
    test (count $argv) -ge 1; or begin
        echo "uso: in <pacote> ..."
        return 1
    end
    switch (__pkg_kind)
        case dnf
            sudo dnf install -y $argv
        case pacman
            sudo pacman -S --noconfirm $argv
        case apt
            sudo apt install -y $argv
        case none
            echo "Nenhum gerenciador de pacotes comum encontrado."
            return 127
    end
end

function re --description "remover pacote(s)"
    test (count $argv) -ge 1; or begin
        echo "uso: re <pacote> ..."
        return 1
    end
    switch (__pkg_kind)
        case dnf
            sudo dnf remove -y $argv
        case pacman
            sudo pacman -Rns --noconfirm $argv
        case apt
            sudo apt purge -y $argv
        case none
            echo "Nenhum gerenciador de pacotes comum encontrado."
            return 127
    end
end

function se --description "buscar pacote(s)"
    test (count $argv) -ge 1; or begin
        echo "uso: se <termo> ..."
        return 1
    end
    switch (__pkg_kind)
        case dnf
            dnf search $argv
        case pacman
            pacman -Ss $argv
        case apt
            apt search $argv
        case none
            echo "Nenhum gerenciador de pacotes comum encontrado."
            return 127
    end
end

# ----- Qualidade de vida -----
function mkcd --description "cria diretório e entra"
    test (count $argv) -ge 1; or begin
        echo "uso: mkcd <pasta>"
        return 1
    end
    mkdir -p $argv[1]; and cd $argv[1]
end

function extract --description "extrai .zip/.tar.* /.7z/.rar"
    test (count $argv) -ge 1; or begin
        echo "uso: extract <arquivo>"
        return 1
    end
    set f $argv[1]
    switch $f
        case '*.tar.bz2'
            tar xjf $f
        case '*.tar.gz'
            tar xzf $f
        case '*.tar.xz'
            tar xJf $f
        case '*.tbz2' '*.tgz' '*.txz'
            tar xf $f
        case '*.zip'
            unzip -q $f
        case '*.rar'
            unrar x $f
        case '*.7z'
            7z x $f
        case '*'
            echo "Formato não suportado: $f"
            return 2
    end
end

# ----- Integrações opcionais por comando -----
function z --description "zoxide (cd fuzzy) se instalado"
    if type -q zoxide
        command zoxide query -i $argv
    else
        echo "zoxide não instalado."
        return 127
    end
end

# ===== 5.2 — Navegação =====
function ..
    cd ..
end

function ...
    cd ../..
end

function ....
    cd ../../..
end

function .....
    cd ../../../..
end

function ......
    cd ../../../../..
end

function cdg
    cd ~/.config
end

function cddev
    cd /home/lm/leonamsh/
end

function cdprojeto
    cd /home/lm/leonamsh/projeto-mercado-frontend/
end

# ===== 5.3 — Neovim / Emacs =====
set -Ux EDITOR nvim

function v
    nvim $argv
end

function vim
    nvim $argv
end

# atalhos de edição/configuração
function nkitty
    nvim ~/.config/kitty/kitty.conf
end

function nwez
    nvim ~/.config/wezterm/wezterm.lua
end

function nzsh
    nvim ~/.zshrc
end

function nfish
    nvim ~/.config/fish/config.fish
end

function nprojeto
    nvim /home/lm/leonamsh/projeto-mercado/
end

function nsway
    nvim ~/.config/sway
end

function nrascunho
    nvim ~/Documents/rascunhos/
end

# ambientes Neovim
function nvima
    env NVIM_APPNAME=astronvim nvim $argv
end

function nvimc
    env NVIM_APPNAME=nvchad nvim $argv
end

function nviml
    env NVIM_APPNAME=leovim nvim $argv
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
    command emacs --daemon
end

function kemacs
    killall emacs
end

function stowa
    stow . --adopt
end

function srcfish
    source .config/fish/config.fish
end
