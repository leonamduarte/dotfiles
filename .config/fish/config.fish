# ==========================================================
# Fish Config — CachyOS (Arch Based)
# SysAdmin: Linux | Data: 2025
# ==========================================================

# ----------------------------------------------------------
# 0) Verificação de Interatividade
# ----------------------------------------------------------
if status is-interactive

    # ----------------------------------------------------------
    # 1) PATHs e Variáveis de Ambiente
    # ----------------------------------------------------------
    fish_add_path $HOME/.local/bin
    fish_add_path $HOME/bin
    fish_add_path /usr/local/bin
    fish_add_path $HOME/.cargo/bin
    fish_add_path /home/bashln/.npm-global/bin

    # Neovim manual (se existir, embora no Arch usemos o do repo geralmente)
    if test -d /opt/nvim-linux-x86_64/bin
        fish_add_path /opt/nvim-linux-x86_64/bin
    end

    # Editor Padrão
    set -gx EDITOR nvim

    # ----------------------------------------------------------
    # 2) Configurações Nativas do Fish
    # ----------------------------------------------------------
    set -U fish_greeting ""

    # ----------------------------------------------------------
    # 3) Ferramentas Modernas
    # ----------------------------------------------------------

    # Starship
    if type -q starship
        starship init fish | source
    end

    # Zoxide
    if type -q zoxide
        zoxide init fish | source
        alias cd='z'
    end

    # Node.js (fnm)
    set -gx FNM_PATH "$HOME/.local/share/fnm"
    fish_add_path $FNM_PATH
    if type -q fnm
        fnm env --use-on-cd | source
    end

    # fzf
    if type -q fzf
        fzf --fish | source
    end

    # ----------------------------------------------------------
    # 4) Aliases e Abreviações
    # ----------------------------------------------------------

    # --- LS (eza) ---
    if type -q eza
        alias ls='eza -al --color=always --group-directories-first --icons'
        alias la='eza -a  --color=always --group-directories-first --icons'
        alias ll='eza -l  --color=always --group-directories-first --icons'
        alias lt='eza -aT --color=always --group-directories-first --icons'
        alias l.='eza -a | grep -e "^\."'
    end

    # --- Git ---
    abbr --add gs 'git status'
    abbr --add ga 'git add -A'
    abbr --add gc 'git commit -m'
    abbr --add gp 'git push'
    abbr --add gl 'git pull'
    abbr --add gco 'git checkout'
    abbr --add clone 'git clone'
    abbr --add lz lazygit

    # --- Navegação ---
    abbr --add .. 'cd ..'
    abbr --add ... 'cd ../..'
    abbr --add .... 'cd ../../..'

    abbr --add cdg 'cd ~/.config'
    abbr --add cddev 'cd ~/bashln/'
    abbr --add cdprojeto 'cd ~/bashln/projeto-mercado'

    # --- Editores ---
    alias v='nvim'
    alias vim='nvim'

    abbr --add nkitty 'nvim ~/.config/kitty/kitty.conf'
    abbr --add nwez 'nvim ~/.config/wezterm/wezterm.lua'
    abbr --add nzsh 'nvim ~/.zshrc'
    abbr --add nfish 'nvim ~/.config/fish/config.fish'

    # Ambientes Neovim
    alias nvima='NVIM_APPNAME=astronvim nvim'
    alias nvimc='NVIM_APPNAME=nvchad nvim'
    alias nviml='NVIM_APPNAME=lazyvim nvim'

    # --- Sistema (PACMAN / ARCH) ---
    # Anatomia: -S (Sync), -y (Refresh DB), -u (Sys Upgrade)
    # Importante: No Arch, evitamos o flag '--noconfirm' em aliases de update 
    # para garantir que você leia a lista de pacotes antes de quebrar algo.

    abbr --add update 'sudo pacman -Syu'
    abbr --add install 'sudo pacman -S'
    abbr --add search 'pacman -Ss'

    # Remoção Segura e Recursiva
    # -R (Remove), -s (Recursive/Dependencies), -n (No backup files)
    abbr --add remove 'sudo pacman -Rsn'

    # Limpeza de Orfãos (Equivalente ao autoremove)
    # Qtdq: Query, deps não requeridas (t), deps de deps (d), quiet (q)
    abbr --add cleanup 'sudo pacman -Qtdq | sudo pacman -Rns -'

    # Logs do sistema
    abbr --add jctl 'journalctl -p 3 -xb'

    # Compressão
    alias tarnow='tar -acf '
    alias untar='tar -zxvf '

    # --- Pessoais ---
    abbr --add srcfish 'source ~/.config/fish/config.fish'
    abbr --add cdaula 'cd ~/gitlab/maisPraTi/'
    abbr --add exithypr 'hyprctl dispatch exit'
    abbr --add ask gemini
    abbr --add yay paru
    abbr --add vpninova 'sudo openvpn --config ~/Downloads/sslvpn-itinerario@inova.local-client-config.ovpn --daemon'
    abbr --add doomsync './.config/emacs/bin/doom sync'
    abbr --add doomsupd './.config/emacs/bin/doom upgrade'
    abbr --add dotsize 'du -sh .git && git count-objects -vH'

    # ----------------------------------------------------------
    # 5) Funções
    # ----------------------------------------------------------

    function log
        set -l cmd $argv
        set -l base ()
        set -l ts (date +%Y%m%d-%H%M%S)
        eval $cmd 2>&1 | tee "$base-$ts.log"
    end

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    function fopen
        set -l root "."
        if test -n "$argv[1]"
            set root "$argv[1]"
        end
        fd -t f -H -0 . "$root" | fzf --read0 --multi --select-1 --exit-0 \
            --bind 'enter:execute-silent(xdg-open {+})+abort' \
            --prompt='files> '
    end

end
