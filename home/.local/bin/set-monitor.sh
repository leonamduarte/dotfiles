#!/bin/bash

# Configura segundo monitor no Fedora (KDE Wayland)
# Força resolução via parâmetro kernel no GRUB

GRUB_FILE="/etc/default/grub"
MONITOR_NAME="DP-1"
RESOLUTION="1440x900"
REFRESH_RATE="75"

# Backup
sudo cp "$GRUB_FILE" "${GRUB_FILE}.bak"

# Adiciona ou substitui video= no GRUB_CMDLINE_LINUX_DEFAULT
if sudo grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=.*video=" "$GRUB_FILE"; then
    sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/video=[^ '\"\`]*/video=$MONITOR_NAME:$RESOLUTION@$REFRESH_RATE/" "$GRUB_FILE"
else
    sudo sed -i -E "s/^(GRUB_CMDLINE_LINUX_DEFAULT=['\"])(.*)(['\"])/\1\2 video=$MONITOR_NAME:$RESOLUTION@$REFRESH_RATE\3/" "$GRUB_FILE"
fi

echo "Parâmetro adicionado:"
grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "$GRUB_FILE"

# Regerar GRUB (Fedora usa grub2-mkconfig)
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo ""
echo "Reinicie para aplicar: sudo reboot"
