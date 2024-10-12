#!/bin/bash

killall -q polybar
sleep 2

~/.config/polybar/scripts/brightness_notify.sh

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload toph &
  done
else
  polybar --reload toph &
fi
