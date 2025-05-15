#!/bin/bash

# Check if rofi is running
if pgrep -x rofi >/dev/null; then
    pkill -x rofi
else
    rofi -modi drun,run -show drun
fi
