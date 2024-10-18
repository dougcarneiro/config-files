#!/bin/bash

power_status=$(bluetoothctl show | grep "Powered: yes")
device_connected=$(bluetoothctl info | grep "Connected: yes")
audio_output_mac_address=$(pactl list sinks short | grep bluez_output | sed -E 's/.*bluez_output\.([0-9A-Fa-f_]+)\..*/\1/' | sed 's/_/:/g')

if [ "$power_status" ]; then
    if [ "$device_connected" ]; then
        device_audio=$(bluetoothctl info "$audio_output_mac_address" | grep "Audio Sink")
        # Checks if connected device supports audio sink
        if [ "$device_audio" ]; then
            # Checks if connected device outputs its battery percentage
            device_percentage=$(bluetoothctl info "$audio_output_mac_address" | grep "Battery" | awk '{print $4}' | tr -d '()')
            if [ "$device_percentage" ]; then
                echo " $device_percentage%"
            fi
        else
            echo " "
        fi
    else
        echo ""
    fi
else
    echo ""
fi

