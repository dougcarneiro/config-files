#!/bin/bash

BRIGHTNESS_FILE="$HOME/.config/polybar/scripts/.brightness_value"

if [ ! -f "$BRIGHTNESS_FILE" ]; then
    echo "󰃠 $(brightnessctl g -P)%" > "$BRIGHTNESS_FILE"
fi

get_brightness() {
    brightnessctl g | awk -v max=$(brightnessctl m) '{printf "%.0f", ($1/max)*100}'
}

update_polybar() {
    BRIGHTNESS=$(get_brightness g -P)
    echo "󰃠 $BRIGHTNESS%" > "$BRIGHTNESS_FILE"
    polybar-msg hook brightness 1
    (sleep 5 && echo "" > "$BRIGHTNESS_FILE" && polybar-msg hook brightness 2) &
}

update_polybar
