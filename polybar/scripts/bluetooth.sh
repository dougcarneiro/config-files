#!/bin/bash

# Verifica se o Bluetooth está ligado
power_status=$(bluetoothctl show | grep "Powered: yes")

# Verifica se existe algum dispositivo conectado
device_connected=$(bluetoothctl info | grep "Connected: yes")

if [ "$power_status" ]; then
    if [ "$device_connected" ]; then
        # Ícone para Bluetooth ligado e dispositivo conectado
        echo " "
    else
        # Ícone para Bluetooth ligado, mas sem dispositivos conectados
        echo ""
    fi
else
    # Ícone para Bluetooth desligado
    echo ""
fi

