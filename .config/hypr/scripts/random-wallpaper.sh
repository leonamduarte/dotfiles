#!/bin/bash

# pasta com os wallpapers
WALLPAPER_DIR="/run/media/lm/dev/walls/catppuccin"

# escolhe uma imagem aleatória
IMG=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# mata swaybg anterior (pra não acumular processo)
pkill swaybg

# aplica o novo wallpaper
swaybg -i "$IMG" -m fill &
