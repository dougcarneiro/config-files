#!/bin/bash

if ! pgrep -x "picom" > /dev/null
then
    # Start picom only if it hasn't been initiated yet
    picom &
fi
