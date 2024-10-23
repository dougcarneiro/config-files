#!/bin/bash

sleep 1

if xrandr | grep "HDMI-1 connected"; then
  # Monitor externo conectado
  xrandr --output eDP-1 --right-of HDMI-1 --auto --output HDMI-1 --auto --primary
else
  # Apenas monitor do laptop
  xrandr --output HDMI-1 --off --output eDP-1 --auto --primary
fi

