#!/bin/bash

# Function to kill existing instances
run_once() {
    local program="$1"
    pkill -f "$program" 2>/dev/null
    "$program" &
}

run_once nm-applet
run_once volumeicon
run_once blueman-applet
run_once cbatticon -l 20 -r 10 -o "notify-send 'Battery is at 20%'" -c "notify-send 'Battery is at 10%'"
run_once batsignal
run_once picom
run_once keepassxc
run_once flameshot
run_once discord
run_once udiskie
run_once slack

# Disable sleep and screen saver
xset s off
xset -dpms
xset s noblank

# Change the keyboard key caps_lock to ctrl
xmodmap ~/.Xmodmap
