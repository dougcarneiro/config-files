#!/bin/bash

for i in /sys/class/hwmon/hwmon*/temp*_input; do
    label="$(cat "${i%_*}_label" 2>/dev/null || echo $(basename ${i%_*}))"
    if [[ "$label" == "Tctl" ]]; then
        export CPU_TEMP_PATH="$(readlink -f "$i")"
        break
    elif [[ "$label" == "CPU" ]]; then
        export CPU_TEMP_PATH="$(readlink -f "$i")"
        break
    fi
done

if [ -z "$CPU_TEMP_PATH" ]; then
    echo "Error: CPU temp path not found."
    exit 1
fi
