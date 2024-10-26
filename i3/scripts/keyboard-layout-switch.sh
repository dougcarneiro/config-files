#!/bin/bash

xkb-switch -n

notify-send "Keyboard Layout <$(xkb-switch)>" -i /home/douglas/config-files/dunst/icons/preferences-desktop-keyboard.svg --expire-time 5000 --hint=string:x-canonical-private-synchronous:"unique_id"
