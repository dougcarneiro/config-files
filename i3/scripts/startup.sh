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

# Creating lock image
# We use maim to take a picture of the screen, then we give it a pixelated feel with gm
IMG="/tmp/lock_screen.png" && maim "$IMG" && gm convert $IMG -scale 10% -scale 1000% -fill black -colorize 25% $IMG

# xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
# screen before suspend. Use loginctl lock-session to lock your screen.
if ! pgrep -x "xss-lock" > /dev/null
then
    # Start xss-lock only if it hasn't been initiated yet
    xss-lock --transfer-sleep-lock -- i3lock --nofork -i /tmp/lock_screen.png &
fi

