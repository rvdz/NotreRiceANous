#!/bin/bash

eth_con=0
wifi_con=0
icon=""

# Check whether connection is wifi or ethernet
for d in /sys/class/net/*; do
    dir_name=$(basename "$d")
    # Ignore loopback connection
    if [[ -d "$d" && "$dir_name" != "lo" ]]; then
        con=$(cat "$d/carrier" 2> /dev/null)
        # if connected, check whether connection is wifi or ethernet
        if [[ "$con" == "1" ]]; then
            if [[ "$dir_name" =~ "w" ]]; then
                wifi_con=1
                icon=""
            else
                eth_con=1
                icon="⇅"
            fi
        fi
    fi
done

# Check effective internet connection
wget --spider google.com 2> /dev/null
if [ "$?" != 0 ]; then
    icon=""
fi

if [ "$eth_con" -eq 1 ] && [ "$wifi_con" -eq 0 ]; then
    # Ethernet connection
	echo " $icon Ethernet "

elif [ "$wifi_con" -eq 1 ]; then
    # Wifi connection
    name=$(/sbin/iwconfig 2>/dev/null | grep "\"" | head -n 1 | sed -r 's/^.*ESSID:"(.+)".*$/\1/g')
    sig_quality=$(/sbin/iwconfig 2>/dev/null | tail -n +2 | grep -i "quality" | sed -r 's/^.*Quality=([0-9]+\/[0-9]+).*$/100*\1/g' | bc)
    if [ $sig_quality > 0 ]; then
        echo " $icon $name ($sig_quality%)"
    else
        echo " $icon $name "
    fi

else
    # No connection
	echo " (Not Connected) "
	exit 0
fi

