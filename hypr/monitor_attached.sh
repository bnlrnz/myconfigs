#!/usr/bin/env bash

hyprctl dispatch moveworkspacetomonitor 1 "$1"
hyprctl dispatch workspace 1
hyprctl dispatch moveworkspacetomonitor 3 "$1"

pkill -f wpaperd; wpaperd &
pkill -f waybar; waybar &
