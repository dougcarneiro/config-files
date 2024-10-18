#!/bin/bash

TOUCHPAD_ID=$(xinput list | grep Touchpad | awk '{print $6}' | sed 's/id=//')

xinput set-prop $TOUCHPAD_ID "libinput Natural Scrolling Enabled" 1
xinput set-prop $TOUCHPAD_ID "libinput Tapping Enabled" 1
xinput setprop $TOUCHPAD_ID "libinput Accel Speed" 0.250
