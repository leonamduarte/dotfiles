#!/usr/bin/env bash
#
# Script para menu de logout no Qtile usando dmenu/rofi
# Dependências: rofi (ou dmenu), systemctl, slock (ou i3lock, etc.)

# Variáveis de comando
DMENU="rofi -dmenu -i -p 'Sair:'"
# Altere "slock" para o seu comando de bloqueio de tela, se for diferente
LOCKER="slock"

# Opções do menu
OPTIONS="Bloquear\nSair\nReiniciar\nDesligar\nSuspender"

# Use o comando `echo` para passar as opções para o dmenu/rofi e capturar a escolha
choice=$(echo -e "${OPTIONS}" | ${DMENU})

case "$choice" in
"Bloquear")
  # Executa o comando de bloqueio de tela
  ${LOCKER}
  ;;
"Sair")
  # Comando para encerrar o Qtile, voltando para o gerenciador de login
  qtile cmd-obj -o cmd -f shutdown
  ;;
"Reiniciar")
  # Comando do systemd para reiniciar o sistema
  systemctl reboot
  ;;
"Desligar")
  # Comando do systemd para desligar o sistema
  systemctl poweroff
  ;;
"Suspender")
  # Comando do systemd para suspender o sistema
  systemctl suspend
  ;;
esac
