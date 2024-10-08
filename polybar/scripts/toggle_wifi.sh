#!/bin/bash

wifi_status=$(nmcli -t -f WIFI g)

if [[ "$wifi_status" == "enabled" ]]; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
