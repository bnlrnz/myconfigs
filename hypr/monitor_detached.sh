#!/usr/bin/env bash

sleep 3
pkill -f waybar; waybar &
pkill -f wpaperd; wpaperd &
