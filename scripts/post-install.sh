#!/usr/bin/env bash

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Atualiza índices antes de instalar
sudo apt-get update -y || true

apt_install() {
  local pkg="$1"
  echo "📦 Instalando: $pkg"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "✅ Já instalado: $pkg"
    return 0
  fi
  if ! sudo apt-get install -y "$pkg"; then
    echo "⚠️  Falhou: $pkg (seguindo em frente)"
    return 1
  fi
}


echo -e "\n#-------------------- INICIANDO PÓS-INSTALAÇÃO (Ubuntu) --------------------#\n"

# Pacotes essenciais (cada um tenta e segue em frente)
for pkg in \
  curl unzip git jq ntfs-3g gedit emacs \
  fonts-firacode fonts-jetbrains-mono fonts-ubuntu \
  alacritty vlc steam \
  feh numlockx kitty variety gvfs dosbox samba xfce4-power-manager lxappearance flameshot \
  wine winetricks \
  vulkan-tools mesa-vulkan-drivers libvulkan1 vkd3d; do
  apt_install "$pkg" || true
done

# Snap (opcional)
if command -v snap >/dev/null 2>&1; then
  echo "▶ Atualizando snaps..."
  sudo snap refresh || true
fi

# Flatpak (opcional)
if command -v flatpak >/dev/null 2>&1; then
  echo "▶ Atualizando flatpaks..."
  flatpak update -y || true
fi

# Micro-correções comuns
sudo fc-cache -fv || true

echo -e "\n✅ Pós-instalação concluída com sucesso!\n"
