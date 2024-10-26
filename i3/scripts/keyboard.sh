#!/bin/bash

LAYOUTS="us,br"

# First we need to redefine keyboard layout configuration to bare minimum
setxkbmap -layout us -option ""
# Use `localectl list-x11-keymap-options | grep grp:` to view all possibles shortcuts for layout toggle
setxkbmap -model pc105 -layout $LAYOUTS -option grp:ctrls_toggle,compose:ralt

