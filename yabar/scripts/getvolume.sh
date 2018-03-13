#!/bin/bash

# Check if the sound is muted or not.
if [ ! -z "$(amixer get Master | grep off)" ]; then
    if [ "$HEADPHONES" = "true" ]; then
        echo "  Mute "
    else
        echo "  Mute "
    fi
else
    # The sound is not muted get the volume and print it out.
    volume=$(amixer get Master |grep % | head -n 1 | sed -r 's/^.*\[([0-9]+)%\].*$/\1/g' )
    if [ "$HEADPHONES" = "true" ]; then
        prefix="  "
    elif [[ $volume -eq 0 ]]; then
        prefix="   "
    else
        prefix="   "
    fi
    echo "$prefix$volume% "
fi
