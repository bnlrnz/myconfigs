#!/usr/bin/env bash

pkill -f waybar; waybar &
pkill -f wpaperd; wpaperd &

hyprctl dispatch workspace 1
