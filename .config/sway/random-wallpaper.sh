#!/usr/bin/env bash
set -euo pipefail

# pasta com seus wallpapers
WALLPAPER_DIR="$HOME/Pictures/walls/catppuccin"

# escolhe um arquivo aleatório
img="$(find "$WALLPAPER_DIR" -type f | shuf -n1)"

# aplica no swaybg
swaybg -i "$img" -m fill &

