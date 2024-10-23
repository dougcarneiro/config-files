#!/bin/bash

~/.config/i3/scripts/detect-monitors.sh
~/.config/i3/scripts/workspace-setup.sh
~/.config/i3/scripts/config-touchpad.sh
~/.config/i3/scripts/keyboard.sh
~/.config/i3/scripts/set-wallpaper.sh

# Making sure to start picom after xrandr configs are all set and done
if ! pgrep -x "picom" > /dev/null
then
    # Start picom only if it hasn't been initiated yet
    picom &
fi

