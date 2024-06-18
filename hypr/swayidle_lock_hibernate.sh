#!/bin/sh

if [ $(hostname) = "nix" ]; then
  swayidle -w \
    timeout 1200 'systemctl suspend' 
else
  swayidle -w \
    timeout 300 'swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 20 --fade-in 0.2'\
    timeout 310 'if pgrep swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on' \
    timeout 1200 'systemctl suspend' resume 'hyprctl dispatch dpms on' \
    before-sleep 'swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 20 --fade-in 0.2'
fi
