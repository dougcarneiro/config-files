#!/bin/bash

# Definir as opções do menu
OPTIONS="  Suspend\n  Logout\n  Restart\n  Poweroff"

# Mostrar o menu e capturar a escolha do usuário
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Escolha uma opção:" -i -theme powermenu)

# Executar comandos com base na escolha
case "$CHOICE" in
    "  Suspend")
        systemctl suspend
        ;;
    "  Logout")
        i3-msg exit
        ;;
    "  Restart")
        systemctl reboot
        ;;
    "  Poweroff")
        systemctl poweroff
        ;;
    *)
        ;;
esac

