#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 --raise | --lower | --toggle-mute | --toggle-mic-mute"
    exit 1
fi

get_volume() {
    amixer get Master | grep -o -m 1 "[0-9]*%" | sed "s/%//"
}

get_volume_mic() {
    amixer get Capture | grep -o -m 1 "[0-9]*%" | sed "s/%//"
}

get_volume_icon() {
    current_level=$1
    if [[ $current_level -eq 0 ]] || pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
        echo "$HOME/.config/dunst/icons/audio-volume-muted-symbolic.svg"
    elif [[ $current_level -le 26 ]]; then
        echo "$HOME/.config/dunst/icons/audio-volume-low-symbolic.svg"
    elif [[ $current_level -le 69 ]]; then
        echo "$HOME/.config/dunst/icons/audio-volume-medium-symbolic.svg"
    else
        echo "$HOME/.config/dunst/icons/audio-volume-high-symbolic.svg"
    fi
}


case "$1" in
    --raise)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        VOLUME=$(get_volume)
        ICON=$(get_volume_icon $VOLUME)
        notify-send "Volume $VOLUME%" -i $ICON --expire-time=5000 --hint=string:x-canonical-private-synchronous:"unique_id" --hint=int:value:$VOLUME -u low
        ;;
    --lower)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        VOLUME=$(get_volume)
        ICON=$(get_volume_icon $VOLUME)
        notify-send "Volume $VOLUME%" -i $ICON --expire-time=5000 --hint=string:x-canonical-private-synchronous:"unique_id" --hint=int:value:$VOLUME -u low
        ;;
    --toggle-mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        VOLUME=$(get_volume)
        ICON=$(get_volume_icon $VOLUME)
        if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
            notify-send "Volume MUTED" -i $ICON --expire-time=5000 --hint=string:x-canonical-private-synchronous:"unique_id" --hint=int:value:0 -u low
        else
            notify-send "Volume $VOLUME%" -i $ICON --expire-time=5000 --hint=string:x-canonical-private-synchronous:"unique_id" --hint=int:value:$VOLUME -u low
        fi
        ;;
    --toggle-mic-mute)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
            notify-send "Microphone MUTED" -i "$HOME/.config/dunst/icons/microphone-sensitivity-muted-symbolic.svg" --expire-time=5000 --hint=string:x-canonical-private-synchronous:"unique_id" --hint=int:value:0 -u low
        else
            VOLUME_MIC=$(get_volume_mic)
            notify-send "Microphone unmuted" -i "$HOME/.config/dunst/icons/audio-input-microphone-symbolic.svg" --expire-time=5000 --hint=string:x-canonical-private-synchronous:"unique_id" --hint=int:value:$VOLUME_MIC -u low
        fi
        ;;

    *)
        echo "Invalid option. Use: --raise | --lower | --toggle-mute | --togle-mic-mute"
        exit 1
        ;;
esac
