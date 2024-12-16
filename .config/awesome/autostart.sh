#!/bin/bash
nm-applet &
volumeicon &
blueman-applet &
cbatticon &
batsignal &
picom &
keepassxc &
# teams-for-linux &
killall polybar
polybar -r example &
flameshot &
# fdm &
discord &
xdman-beta &
udiskie &

# Disable sleep and screen saver
xset s off
xset -dpms
xset s noblank

# Change the keyboard key caps_lock to ctrl
xmodmap ~/.Xmodmap
