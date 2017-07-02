#!/bin/bash

config=$(/sbin/iwconfig 2>/dev/null | head -n 1)
# No connection
if [[ -z $(echo "$config" | grep 'ESSID:"') ]]; then
	echo "(Not Connected)"
	exit 0
fi

type=$(echo "$config" | awk '{print $1}')
name=$(echo "$config" | sed -r 's/^.*ESSID:"(.+)".*$/\1/g')
sig_quality=$(/sbin/iwconfig 2>/dev/null | tail -n +2 | grep -i "quality" | sed -r 's/^.*Quality=([0-9]+\/[0-9]+).*$/100*\1/g' | bc)

if [ $(echo "$type" | grep wlan) ]; then
	echo " $name ($sig_quality%)" 
else
	echo " $name ($sig_quality%)" 
fi
