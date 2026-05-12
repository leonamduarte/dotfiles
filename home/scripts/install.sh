#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
#DOTFILES_DIR="$HOME/dotfiles"
TARGET_DIR="$HOME"

echo "==> Dotfiles: $DOTFILES_DIR"
echo "==> Target:  $TARGET_DIR"

# Backup existing files
backup_file() {
    local file="$1"
    if [ -e "$file" ] || [ -L "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
        echo "    backing up: $file → $backup"
        mv "$file" "$backup"
    fi
}

remove_matching_symlink() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        echo "    removing existing matching symlink: $dst"
        rm -f "$dst"
    fi
}

canonicalize_path() {
    local path="$1"
    if [ -e "$path" ]; then
        readlink -f "$path"
    else
        printf '%s\n' "$path"
    fi
}

prepare_stow_targets() {
    local item
    local rel
    local name

    shopt -s dotglob nullglob

    for item in "$DOTFILES_DIR/home"/*; do
        [ -e "$item" ] || continue
        name="$(basename "$item")"
        remove_matching_symlink "$item" "$TARGET_DIR/$name"
    done

    if [ -d "$DOTFILES_DIR/home/.config" ]; then
        for item in "$DOTFILES_DIR/home/.config"/*; do
            [ -e "$item" ] || continue
            name="$(basename "$item")"
            remove_matching_symlink "$item" "$TARGET_DIR/.config/$name"
        done
    fi

#    if [ -d "$DOTFILES_DIR/home/.local" ]; then
#        for item in "$DOTFILES_DIR/home/.local"/*; do
#            [ -e "$item" ] || continue
#            name="$(basename "$item")"
#            remove_matching_symlink "$item" "$TARGET_DIR/.local/$name"
#        done
#    fi

    shopt -u dotglob nullglob
}

# Install Oh My Zsh custom plugins (fish-like features)
install_ohmyzsh_plugins() {
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    echo ""
    echo "==> Installing Oh My Zsh plugins..."

    if [ ! -d "$custom_dir/zsh-autosuggestions" ]; then
        echo "    installing zsh-autosuggestions..."
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$custom_dir/zsh-autosuggestions"
    else
        echo "    zsh-autosuggestions already installed"
    fi

    if [ ! -d "$custom_dir/zsh-syntax-highlighting" ]; then
        echo "    installing zsh-syntax-highlighting..."
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$custom_dir/zsh-syntax-highlighting"
    else
        echo "    zsh-syntax-highlighting already installed"
    fi
}

install_ohmyzsh_plugins

# Install using GNU Stow if available
if command -v stow &>/dev/null; then
    echo "==> Using GNU Stow..."
    cd "$DOTFILES_DIR"

    prepare_stow_targets

    echo "    installing package: home"
    stow -t "$TARGET_DIR" -S home

    echo "==> Done! Dotfiles installed successfully."
else
    echo "==> GNU Stow not found, using manual symlinks..."
    echo "    (Consider installing: apt install stow)"

    install_file() {
        local src="$DOTFILES_DIR/$1"
        local dst="$TARGET_DIR/$1"

        if [ -e "$dst" ] || [ -L "$dst" ]; then
            backup_file "$dst"
        fi

        echo "    linking: $1"
        mkdir -p "$(dirname "$dst")"
        ln -sf "$src" "$dst"
    }

    # Install all files from home/ package
    for item in "$DOTFILES_DIR/home"/*; do
        [ -e "$item" ] || continue
        name="$(basename "$item")"
        install_file "$name"
    done

    # Also handle .config subdirs
    if [ -d "$DOTFILES_DIR/home/.config" ]; then
        for item in "$DOTFILES_DIR/home/.config"/*; do
            [ -e "$item" ] || continue
            name="$(basename "$item")"
            install_file ".config/$name"
        done
    fi

    # Handle .local
    if [ -d "$DOTFILES_DIR/home/.local" ]; then
        for item in "$DOTFILES_DIR/home/.local"/*; do
            [ -e "$item" ] || continue
            name="$(basename "$item")"
            install_file ".local/$name"
        done
    fi

    echo "==> Done! Dotfiles installed successfully."
fi

# Configure zsh as default shell (Fedora)
configure_zsh() {
    local zsh_path
    local current_shell
    local canonical_zsh_path
    local canonical_current_shell

    echo ""
    echo "==> Configuring zsh..."

    # Check if zsh is installed
    if ! command -v zsh &>/dev/null; then
        echo "    zsh not found, installing..."
        if command -v dnf &>/dev/null; then
            sudo dnf install -y zsh
        else
            echo "    WARNING: Cannot install zsh automatically. Please install manually."
            return
        fi
    fi

    # Verify zsh path
    zsh_path="$(command -v zsh)"
    canonical_zsh_path="$(canonicalize_path "$zsh_path")"
    echo "    zsh found at: $zsh_path"

    # Check if zsh is in /etc/shells
    if ! grep -q "$zsh_path" /etc/shells; then
        echo "    Adding zsh to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    # Change default shell
    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
    canonical_current_shell="$(canonicalize_path "$current_shell")"
    if [ "$canonical_current_shell" != "$canonical_zsh_path" ]; then
        echo "    Changing default shell to zsh..."
        chsh -s "$zsh_path"
        echo "    Shell changed! Restart your session or run: exec $zsh_path"
    else
        echo "    zsh is already your default shell."
    fi
}

configure_zsh

echo ""
echo "==> Restart your shell or run 'source ~/.zshrc' to apply changes."
