#!/bin/bash

# Arquivo temporário para armazenar o valor de brilho
BRIGHTNESS_FILE="/tmp/brightness_value"

# Pega o valor de brilho atual
get_brightness() {
    brightnessctl g | awk -v max=$(brightnessctl m) '{printf "%.0f", ($1/max)*100}'
}

# Atualiza a barra do polybar com o brilho atual e mostra a notificação
update_polybar() {
    # Pega o valor de brilho e escreve no arquivo temporário
    BRIGHTNESS=$(get_brightness)
    echo "󰃠 $BRIGHTNESS%" > "$BRIGHTNESS_FILE"

    # Atualiza o módulo da polybar
    polybar-msg hook brightness 1

    # Oculta a notificação após 5 segundos
    (sleep 5 && echo "" > "$BRIGHTNESS_FILE" && polybar-msg hook brightness 2) &
}

# Executa a função para atualizar a polybar
update_polybar
