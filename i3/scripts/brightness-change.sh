#!/bin/bash

adjustment=5

get_brightness() {
    if brightness=$(brightnessctl g -P 2>/dev/null); then
        echo "$brightness"
    else
        echo "$(echo "$(brightnessctl g) * 100 / $(brightnessctl m)" | bc)"
    fi
}

current_brightness=$(get_brightness)

if [ -z "$current_brightness" ]; then
    echo "Error: current brightness not availiable."
    exit 1
fi

case "$1" in
    --lower)
        brightness=$(($current_brightness - adjustment))
        ;;
    --raise)
        brightness=$(($current_brightness + adjustment))
        ;;
    *)
        echo "Usage: $0 --lower | --raise"
        exit 1
        ;;
esac

brightnessctl s "$brightness%" && \
new_brightness=$(get_brightness) && \
notify-send "Brightness $new_brightness%" \
  -i "$HOME/.config/dunst/icons/preferences-system-brightness-lock.svg" \
  --expire-time=5000 \
  --hint=string:x-canonical-private-synchronous:"unique_id" \
  --hint=int:value:$new_brightness \
  -u low && \
echo "$new_brightness" > ~/.config/i3/.brightness-value
