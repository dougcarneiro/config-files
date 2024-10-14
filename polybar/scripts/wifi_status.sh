#!/bin/bash

interface=$(ip link | grep -oP '(wlp\w+|wlx\w+|wlan\w+|enp\w+)' | head -1)

wifi_status=$(nmcli -t -f WIFI g)

ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

icon_disconnected="wifi off"
icon_connected=""

if [[ "$wifi_status" == "enabled" && -n "$ssid" ]]; then
    echo "$icon_connected"
else
    echo "$icon_disconnected"
fi
