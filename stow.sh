#!/bin/bash
cd "$(dirname "$0")"

# Aplica stow para todos os pacotes
stow -v -t ~/.config -d config/.config $(ls -d config/.config/*/ | xargs -n1 basename)
stow -v -t ~ shell git

# Pacotes que devem ser diretórios (mesmo sem subdiretórios no repo)
DIR_PACKAGES="fish nvim opencode alacritty ghostty kitty neovide niri picom qtile rofi-bashln waybar wezterm yazi"

# Remove arquivos que o stow criou incorretamente (como arquivos soltos)
for ext in lua json jsonc toml conf rasi md txt el py; do
    rm -f ~/.config/*.$ext 2>/dev/null
done
rm -f ~/.config/config.fish ~/.config/fish_variables ~/.config/init.lua ~/.config/lazy-lock.json 2>/dev/null
rm -f ~/.config/opencode.json ~/.config/tui.json ~/.config/prompts ~/.config/skills 2>/dev/null

for pkg in $DIR_PACKAGES; do
    # Cria symlink de diretório
    rm -rf ~/.config/$pkg
    ln -sf ../dotfiles/config/.config/$pkg ~/.config/$pkg
done

# Arquivos soltos em config/ que não estão em subdiretórios
ln -sf ../dotfiles/config/mimeapps.list ~/.config/mimeapps.list 2>/dev/null
