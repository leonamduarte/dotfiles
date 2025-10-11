#!/usr/bin/env bash
set -euo pipefail

# ===== Autofs Arch v2 (ext4 dev + NTFS 1TB, com fallback ntfs-3g) =====
# - Idempotente, com backup/rollback do /etc/fstab
# - Automount via systemd (x-systemd.automount,nofail,x-gvfs-hide)
# - Testa ntfs3 RW; se falhar, usa ntfs-3g
# ================================================================

die() {
  echo "❌ $*" >&2
  exit 1
}
ok() { echo "✅ $*"; }
warn() { echo "⚠️  $*"; }
info() { echo "▶ $*"; }

[[ $EUID -eq 0 ]] || die "Execute como root (sudo)."

REAL_USER="${SUDO_USER:-$USER}"
REAL_UID="$(id -u "$REAL_USER")"
REAL_GID="$(id -g "$REAL_USER")"
HOME_DIR="$(getent passwd "$REAL_USER" | cut -d: -f6)"

LABEL_EXT4="${LABEL_EXT4:-dev}"
LABEL_NTFS="${LABEL_NTFS:-1TB}"

DEV_EXT4_CAND="${DEV_EXT4_CAND:-/dev/sda1}"
DEV_NTFS_CAND="${DEV_NTFS_CAND:-/dev/sdb2}"

MP_EXT4="/mnt/dev"
MP_NTFS="/mnt/1TB"

# Helpers
dev_by_label() { blkid -t "LABEL=$1" -o device 2>/dev/null | head -n1 || true; }
uuid_of() { blkid -s UUID -o value "$1" 2>/dev/null || true; }
fstype_of() { lsblk -ndo FSTYPE "$1" 2>/dev/null || true; }

# Encontrar ext4
DEV_EXT4="$(dev_by_label "$LABEL_EXT4")"
[[ -z "$DEV_EXT4" ]] && DEV_EXT4="$DEV_EXT4_CAND"
[[ -b "$DEV_EXT4" ]] || die "Partição ext4 não encontrada (label ${LABEL_EXT4} ou $DEV_EXT4_CAND)."
[[ "$(fstype_of "$DEV_EXT4")" == "ext4" ]] || die "Esperava ext4 em $DEV_EXT4."
UUID_EXT4="$(uuid_of "$DEV_EXT4")"
[[ -n "$UUID_EXT4" ]] || die "Sem UUID para $DEV_EXT4."
ok "ext4: $DEV_EXT4 (UUID=$UUID_EXT4) → $MP_EXT4"

# Encontrar NTFS
DEV_NTFS="$(dev_by_label "$LABEL_NTFS")"
[[ -z "$DEV_NTFS" ]] && DEV_NTFS="$DEV_NTFS_CAND"
[[ -b "$DEV_NTFS" ]] || die "Partição NTFS não encontrada (label ${LABEL_NTFS} ou $DEV_NTFS_CAND)."
FSTYPE_NTFS="$(fstype_of "$DEV_NTFS")"
[[ "$FSTYPE_NTFS" == ntfs || "$FSTYPE_NTFS" == ntfs3 ]] || die "Esperava NTFS em $DEV_NTFS."
UUID_NTFS="$(uuid_of "$DEV_NTFS")"
[[ -n "$UUID_NTFS" ]] || die "Sem UUID para $DEV_NTFS."
ok "ntfs: $DEV_NTFS (UUID=$UUID_NTFS) → $MP_NTFS"

# Preparar pontos
mkdir -p "$MP_EXT4" "$MP_NTFS"

# Encerrar montagens paralelas (GNOME/udisks)
umount -l "/run/media/$REAL_USER/$LABEL_NTFS" 2>/dev/null || true
umount -l "$MP_NTFS" 2>/dev/null || true
systemctl stop mnt-1TB.automount mnt-1TB.mount 2>/dev/null || true

# Verificar se o volume estava sujo (após sua última rodada do ntfsfix deve estar limpo)
if command -v ntfsfix >/dev/null 2>&1; then
  # Só roda ntfsfix se estiver desmontado
  if ! findmnt "$DEV_NTFS" >/dev/null 2>&1; then
    ntfsfix "$DEV_NTFS" >/dev/null || warn "ntfsfix retornou aviso (ok seguir)."
  fi
fi

# Decidir driver NTFS: tentar ntfs3 (RO -> RW). Se RW falhar, usar ntfs-3g.
NTFS_DRIVER="ntfs3"
NTFS_OPTS_BASE="defaults,noatime,uid=${REAL_UID},gid=${REAL_GID},windows_names,x-systemd.automount,nofail,x-gvfs-hide"

info "Testando ntfs3 em RO…"
if mount -t ntfs3 -o ro "$DEV_NTFS" "$MP_NTFS" 2>/dev/null; then
  umount "$MP_NTFS" || true
  info "Testando ntfs3 em RW…"
  if ! mount -t ntfs3 -o "uid=${REAL_UID},gid=${REAL_GID}" "$DEV_NTFS" "$MP_NTFS" 2>/dev/null; then
    warn "ntfs3 RW falhou; caindo para ntfs-3g."
    NTFS_DRIVER="ntfs-3g"
  else
    umount "$MP_NTFS" || true
  fi
else
  warn "ntfs3 RO falhou; usando ntfs-3g."
  NTFS_DRIVER="ntfs-3g"
fi

# Garantir pacote do ntfs-3g se escolhido
if [[ "$NTFS_DRIVER" == "ntfs-3g" ]]; then
  if ! command -v mount.ntfs-3g >/dev/null 2>&1; then
    pacman -S --needed --noconfirm ntfs-3g || die "Falha ao instalar ntfs-3g."
  fi
fi

# Construir linhas do fstab
EXT4_OPTS="defaults,noatime,x-systemd.automount,nofail"
FSTAB_LINE_EXT4="UUID=${UUID_EXT4} ${MP_EXT4} ext4 ${EXT4_OPTS} 0 2"
FSTAB_LINE_NTFS="UUID=${UUID_NTFS} ${MP_NTFS} ${NTFS_DRIVER} ${NTFS_OPTS_BASE} 0 0"

# Editar /etc/fstab com backup e limpeza de entradas antigas dessas montagens
FSTAB="/etc/fstab"
TS="$(date +%Y%m%d-%H%M%S)"
BACKUP="/etc/fstab.bak-${TS}"
TMP="$(mktemp)"
cp -a "$FSTAB" "$BACKUP"
ok "Backup: $BACKUP"

awk -v uuid1="$UUID_EXT4" -v uuid2="$UUID_NTFS" -v mp1="$MP_EXT4" -v mp2="$MP_NTFS" '
BEGIN{IGNORECASE=1}
{
  if ($0 ~ uuid1 || $0 ~ uuid2 || $2 == mp1 || $2 == mp2) next;
  print $0
}
END{}' "$FSTAB" >"$TMP"

{
  echo ""
  echo "# >>> auto-added by autofs-arch-v2 (${TS})"
  echo "$FSTAB_LINE_EXT4"
  echo "$FSTAB_LINE_NTFS"
  echo "# <<<"
} >>"$TMP"

# Validar e aplicar
if ! findmnt --verify -F "$TMP"; then
  mv -f "$BACKUP" "$FSTAB"
  rm -f "$TMP"
  die "findmnt --verify falhou; rollback aplicado."
fi
mv -f "$TMP" "$FSTAB"
systemctl daemon-reload

# Montar tudo e disparar automount tocando os diretórios
mount -a || {
  cp -af "$BACKUP" "$FSTAB"
  systemctl daemon-reload
  die "mount -a falhou; rollback aplicado."
}
ls "$MP_EXT4" >/dev/null 2>&1 || true
ls "$MP_NTFS" >/dev/null 2>&1 || true

# Symlinks amigáveis
ln -sfn "$MP_EXT4" "$HOME_DIR/dev"
ln -sfn "$MP_NTFS" "$HOME_DIR/1TB"
chown -h "$REAL_UID:$REAL_GID" "$HOME_DIR/dev" "$HOME_DIR/1TB"

ok "fstab atualizado com ${NTFS_DRIVER}. Automount pronto."
