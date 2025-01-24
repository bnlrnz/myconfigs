#!/bin/sh

# check if correct host
if [ $(hostname) = "tp-belo" ]; then
  # check if external monitor is NOT attached, ID 0 is the internal monitor
  if [ "$1" == "close" ]; then
    hyprctl keyword monitor "eDP-1, disable"
    #hyprctl reload
    #pkill -f wpaperd
    #wpaperd&
    pkill -f waybar
    waybar&
    internal_monitor_active = hyprctl monitors | grep -c "eDP-1"
    if [internal_monitor_active == 1]; then
      systemctl suspend
    fi
  else
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
    #hyprctl reload
    #pkill -f wpaperd
    #wpaperd&
    pkill -f waybar
    waybar&
  fi
fi
