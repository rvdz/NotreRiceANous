#!/bin/bash

if [[ $1 == -d ]]; then
    current=$(xrandr --verbose | grep -m 1 -i brightness | awk -F' ' '{ print $2 }')
    new=$(echo "$current - 0.1" | bc -l)
    xrandr --output eDP-1 --brightness 0$new
elif [[ $1 == -u ]]; then
    current=$(xrandr --verbose | grep -m 1 -i brightness | awk -F' ' '{ print $2 }')
new=$(echo "$current + 0.1" | bc -l)
    xrandr --output eDP-1 --brightness 0$new
elif [[ $1 == -m ]]; then
    xrandr --output eDP-1 --brightness 1
else
    xrandr --output eDP-1 --brightness $1
fi
