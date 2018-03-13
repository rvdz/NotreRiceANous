#!/bin/bash

nb_bat=$(acpi -b | wc -l)
percent=0

if [ "$nb_bat" -eq "0" ]; then
    echo "   "
    exit 0
fi

for i in $(seq 0 $(($nb_bat-1))); do
	p=$(acpi -b | grep "Battery $i:" | sed 's/%.*//' | sed 's/.*, //')
	percent=$(($percent+p))
done

percent=$(($percent/$nb_bat))

icon=" "

if [ "$percent" -gt 10 ]; then
	icon=" "
fi
if [ "$percent" -gt 35 ]; then
	icon=" "
fi
if [ "$percent" -gt 60 ]; then
	icon=" "
fi
if [ "$percent" -gt 85 ]; then
	icon=" "
fi

if [ -z "$(acpi -b | grep -i "discharging")" ]; then
	echo " $icon $percent% "
else
	echo " $icon $percent% "
fi

exit 0
