#!/bin/bash

tmp=$(cat /sys/class/thermal/thermal_zone0/temp)

echo " "$(($tmp/1000))"°"

exit 0
