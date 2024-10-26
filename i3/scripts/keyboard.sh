#!/bin/bash

# Use `localectl list-x11-keymap-options | grep grp:` to view all possibles shortcuts for layout toggle
setxkbmap -model pc105 -layout us,br -option grp:ctrls_toggle,compose:ralt

