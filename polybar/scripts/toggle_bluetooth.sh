#!/bin/bash

# Alterna o estado do Bluetooth
status=$(bluetoothctl show | grep "Powered: yes")

if [ "$status" ]; then
    bluetoothctl power off
else
    bluetoothctl power on
fi

