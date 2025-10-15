#!/usr/bin/env bash
# Qtile autostart (X11) — robust, idempotent, and XFCE-friendly
# - Starts common system tray applets (network, audio, power, bluetooth, clipboard)
# - Uses xfce4-notifyd for notifications (with Dunst cleanup)
# - Avoids duplicate processes and logs to ~/.cache/qtile/autostart.log
# - Optional extras commented out (picom, redshift/gammastep, wallpaper)

set -Eeuo pipefail

LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/qtile"
LOG_FILE="$LOG_DIR/autostart.log"
mkdir -p "$LOG_DIR"
exec > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >>"$LOG_FILE") 2>&1

echo "=== Qtile autostart begin ==="

# --- Ensure basic PATH includes user bin ---
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/bin:$PATH"

# --- Helper: start if available & not already running ---
run() {
  # usage: run "command with args" [process_name]
  local cmd="$1"
  local name="${2:-$(basename "$1" | awk '{print $1}')}"
  if ! command -v ${cmd%% *} >/dev/null 2>&1; then
    echo "skip: ${cmd%% *} (not found)"
    return 0
  fi
  if pgrep -u "$USER" -x "$name" >/dev/null 2>&1; then
    echo "ok: $name already running"
    return 0
  fi
  echo "start: $cmd"
  nohup bash -lc "$cmd" >/dev/null 2>&1 &
}

# --- Export DBus/X variables for child apps launched by Qtile ---
# Some applets (nm-applet, blueman-applet) rely on a proper session bus/env.
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
  dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_RUNTIME_DIR
fi

# --- Notifications: prefer xfce4-notifyd; stop dunst if running ---
if pgrep -u "$USER" -x dunst >/dev/null 2>&1; then
  echo "stop: dunst (we'll use xfce4-notifyd)"
  killall -q dunst || true
fi

# Many distros auto-start xfce4-notifyd via DBus; manual start is optional.
# Uncomment the next line if notifyd doesn't appear automatically:
# run "/usr/lib/xfce4/notifyd/xfce4-notifyd" "xfce4-notifyd"

# --- Polkit agent (needed for mounting, network auth, etc.) ---
# Try common agents in order (the first available will start).
if ! pgrep -u "$USER" -x polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &&
  ! pgrep -u "$USER" -x xfce-polkit >/dev/null 2>&1; then
  if [ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" "polkit-gnome-authentication-agent-1"
  elif command -v xfce-polkit >/dev/null 2>&1; then
    run "xfce-polkit" "xfce-polkit"
  else
    echo "warn: no polkit agent found"
  fi
fi

# --- System tray applets ---
run "nm-applet" # NetworkManager tray
run "pasystray" # PipeWire/PulseAudio tray (or use volumeicon)
# run "volumeicon"                     # Alternative to pasystray

run "xfce4-power-manager" "xfce4-power-man" # Power/battery + notifications
run "blueman-applet"                        # Bluetooth tray
run "xfce4-clipman" "xfce4-clipman"         # Clipboard manager (X11)

# --- Scripts pessoais ---
~/.config/autostart/xinputI3.sh &         #configura velocidade do mouse
~/.config/autostart/screenResolution.sh & #configura resolução dos 2 monitores corretamente

# --- Programas extras ---
run "steam -silent" "steam"
variety &
# numlockx on &
setxkbmap -layout us -variant intl
clipmenud &
xsettingsd &
feh --randomize --bg-fill /run/media/lm/dev/walls/catppuccin/*

# --- Optional compositor (X11). Uncomment if you want shadows/transparency. ---
# run "picom --experimental-backends" "picom"

# --- Optional color temperature ---
# Prefer gammastep (Wayland friendly) or redshift (X11). On pure X11 either is fine.
# run "gammastep -l geoclue2" "gammastep"
# run "redshift -l geoclue2" "redshift"

# --- Optional screen locker ---
# Requires betterlockscreen or i3lock, and xss-lock to hook idle
# run "xss-lock -- betterlockscreen -l dim" "xss-lock"

# --- Wallpaper (feh) ---
# Update the path to your favorite image or directory.
# if command -v feh >/dev/null 2>&1; then
#   WALL="$HOME/Pictures/wallpapers/default.jpg"
#   [ -f "$WALL" ] && feh --bg-fill "$WALL"
# fi

# --- Keyboard repeat rate (example) ---
# command -v xset >/dev/null 2>&1 && xset r rate 300 40

# --- Cursor (example) ---
# xsetroot -cursor_name left_ptr || true

# --- User-defined hooks ---
# Place any personal startup commands here:
run "copyq" "copyq"
run "flameshot" "flameshot"
# run "syncthing --no-browser" "syncthing"

echo "=== Qtile autostart end ==="
