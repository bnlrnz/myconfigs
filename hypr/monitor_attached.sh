#!/usr/bin/env bash

hyprctl dispatch moveworkspacetomonitor 1 "$1"
hyprctl dispatch workspace 1
hyprctl dispatch moveworkspacetomonitor 3 "$1"

hyprctl dispatch dpms on
pkill -f wpaperd; wpaperd &
pkill -f waybar; waybar &
