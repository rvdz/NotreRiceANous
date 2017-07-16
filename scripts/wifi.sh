#!/bin/bash

eth_con=$(/sbin/ifconfig 2>/dev/null | grep -v "\"" | grep -i ethernet)
wifi_con=$(/sbin/iwconfig 2>/dev/null | grep "\"" | head -n 1)

if [ ! -z "$eth_con" ] && [ -z "$wifi_con" ]; then
    # Ethernet connection
	echo "⇅ Ethernet"

elif [[ $wifi_con ]]; then
    # Wifi connection
    name=$(echo "$wifi_con" | sed -r 's/^.*ESSID:"(.+)".*$/\1/g')
    sig_quality=$(/sbin/iwconfig 2>/dev/null | tail -n +2 | grep -i "quality" | sed -r 's/^.*Quality=([0-9]+\/[0-9]+).*$/100*\1/g' | bc)
    if [ $sig_quality > 0 ]; then
        echo " $name ($sig_quality%)"
    else
        echo " $name"
    fi

else
    # No connection
	echo "(Not Connected)"
	exit 0
fi
