#!/bin/bash
# Deploy dotfiles using chezmoi
# Usage: ./deploy-dotfiles.sh

set -e

SOURCE_DIR="/run/media/dev/stow/dotfiles"
TARGET_DIR="$HOME"

echo "Deploying dotfiles from $SOURCE_DIR"

# Apply chezmoi (if working)
if command -v chezmoi &>/dev/null; then
	echo "Running chezmoi apply..."
	chezmoi apply --force -v || true
fi

# Also copy files manually as backup
echo "Copying config files..."

# .config directory
if [ -d "$SOURCE_DIR/home_.config" ]; then
	rsync -av --ignore-existing "$SOURCE_DIR/home_.config/" "$HOME/.config/"
fi

# .gitignore
if [ -d "$SOURCE_DIR/home_.gitignore" ]; then
	cp "$SOURCE_DIR/home_.gitignore" "$HOME/.gitignore"
fi

echo "Done!"
