#!/bin/bash

image=""
while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
	    -i|--input)
	    image="$2"
	    shift # past argument
	    ;;
	    *)
	            # unknown option
	    ;;
	esac
	shift # past argument or value
done

if [[ -z $image ]]; then
	echo "Synopsis: ./setup -i [filepath]"
	exit 0
fi

# Apply wal for the input image
wal -t -i "$image"

# Load wal color set
source "$HOME/.cache/wal/colors.sh"

# $color0 should be the base background color choosed by wal
bgcolor=$(echo $color0 | sed -r 's/#(\w{6})/\1/g')
# Set the color generated by wal for the bar
if [[ -n $bgcolor ]]; then
	# FIXME grep just the bg color from the bar
	sed -r -i "s/(background-color-argb.*0x\w{2})\w{6}/\1$bgcolor/g" yabar/yabarobin.conf
fi