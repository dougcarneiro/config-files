#!/bin/bash

# Arquivo temporário para armazenar o valor de brilho
BRIGHTNESS_FILE="/tmp/brightness_value"

if [ ! -f "$BRIGHTNESS_FILE" ]; then
    echo "󰃠 $(brightnessctl g -P)%" > "$BRIGHTNESS_FILE"
fi

get_brightness() {
    brightnessctl g | awk -v max=$(brightnessctl m) '{printf "%.0f", ($1/max)*100}'
}

update_polybar() {
    # Pega o valor de brilho e escreve no arquivo temporário
    BRIGHTNESS=$(get_brightness g -P)
    echo "󰃠 $BRIGHTNESS%" > "$BRIGHTNESS_FILE"

    # Atualiza o módulo da polybar
    polybar-msg hook brightness 1

    # Oculta a notificação após 5 segundos
    (sleep 5 && echo "" > "$BRIGHTNESS_FILE" && polybar-msg hook brightness 2) &
}

# Executa a função para atualizar a polybar
update_polybar
