#!/bin/bash

~/.config/i3/scripts/detect-monitors.sh
~/.config/i3/scripts/workspace-setup.sh
~/.config/i3/scripts/set-wallpaper.sh

# Making sure to start picom after xrandr configs are all set and done
~/.config/i3/scripts/picom-startup.sh

# It is a good idea to relaunch polybar everytime we refresh i3 config
~/.config/polybar/scripts/launch_polybar.sh

# Making sure to start xxs-lock after xrandr, workspace and wallpapers config are all set and done
~/.config/i3/scripts/xss-lock.sh

# Setting laptop brightness level correctly based on our last value
~/.config/i3/scripts/brightness-initial-setup.sh
