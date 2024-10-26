#!/bin/bash

BRIGHTNESS_LEVEL="$HOME/.config/i3/.brightness-value"

if [ ! -f "$BRIGHTNESS_FILE" ]; then
    echo "$(brightnessctl g -P)" > "$BRIGHTNESS_LEVEL"
fi

brightnessctl s "$BRIGHTNESS_LEVEL%"
