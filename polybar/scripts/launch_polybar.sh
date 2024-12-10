#!/bin/bash

killall -q polybar

sleep 1

# ~/.config/polybar/scripts/brightness_notify.sh

source ~/.config/polybar/scripts/cpu_temp_path.sh

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph &
  done
else
  polybar --reload toph &
fi
