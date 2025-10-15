#!/usr/bin/env bash

# Lê estado atual do toggle armazenado numa pseudo-var do Hyprland (usamos env var da sessão)
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-gamemode.state"

if [[ -f "$STATE_FILE" ]]; then
  STATE="$(cat "$STATE_FILE")"
else
  STATE="off"
fi

if [[ "$STATE" = "off" ]]; then
  # ====== LIGAR GAMEMODE ======
  hyprctl --batch "
    keyword animations:enabled 0;
    keyword general:gaps_in 0;
    keyword general:gaps_out 0;
    keyword general:border_size 1;

    keyword decoration:active_opacity 1;
    keyword decoration:rounding 0;
    keyword decoration:blur:enabled 0;
    keyword decoration:shadow:enabled 0;

    # (opcional) inibir idle p/ não apagar tela enquanto joga
    keyword misc:enable_swallow 0;
    "

  # Marcar estado
  echo "on" >"$STATE_FILE"

  # Notificação (se tiver mako/volantes)
  notify-send "Hyprland Gamemode" "Ativado: efeitos mínimos, sem gaps, sem animações."
else
  # ====== DESLIGAR GAMEMODE (restaurar seus valores) ======
  hyprctl --batch "
    keyword animations:enabled 1;
    keyword general:gaps_in 5;
    keyword general:gaps_out 8;
    keyword general:border_size 2;

    keyword decoration:active_opacity 1;
    keyword decoration:rounding 4;
    keyword decoration:blur:enabled 1;
    keyword decoration:blur:size 15;
    keyword decoration:blur:passes 2;
    keyword decoration:blur:xray 1;
    keyword decoration:shadow:enabled 0;
    "

  # Se você carrega animações personalizadas num arquivo, recarregue aqui:
  # Ex.: hyprctl reload  (se seu animations.conf já é incluído no hyprland.conf)
  # Obs: estou considerando o seu animations.conf que define curves e animações. :contentReference[oaicite:0]{index=0}

  echo "off" >"$STATE_FILE"
  notify-send "Hyprland Gamemode" "Desativado: valores visuais restaurados."
fi
