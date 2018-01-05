#!/bin/bash

bright=$(xbacklight -get)
round=$(echo $bright | xargs printf "%.*f\n" 0)

# Simple way to prevent turning totally the backlight off
if [[ $round -eq 0 ]]; then
    round=1
fi
if [[ $round -eq 6 ]]; then
    round=5
fi

# Prevent xbacklight small errors to add themselves
xbacklight -set $round -time 0 -steps 1
echo " $round%"
