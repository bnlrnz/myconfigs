#!/bin/sh

# check if correct host
if [ $(hostname) = "tp-belo" ]; then
  # check if external monitor is NOT attached, ID 0 is the internal monitor
  if [ $(hyprctl monitor | grep -q "ID 1") == 1 ]; then
    if [ "$(cat /proc/acpi/button/lid/LID/state)" = "state:      closed" ]; then
      # why was this here?
      #sh ~/.config/hypr/swayidle_lock_hibernate.sh
      exit 0
    fi     
  fi
  if [ "$(cat /proc/acpi/button/lid/LID/state)" = "state:      closed" ]; then
    hyprctl keyword monitor "eDP-1, disable"
    pkill -f wpaperd
    wpaperd&
    pkill -f waybar
    waybar&
  fi
  if [ "$(cat /proc/acpi/button/lid/LID/state)" = "state:      open" ]; then
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
    pkill -f wpaperd
    wpaperd&
    pkill -f waybar
    waybar&
  fi
fi
