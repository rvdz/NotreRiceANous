#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER=$(whoami)

CONFIG_PATH="/home/$USER/NotreRiceANous/menus/Xresources_wifi"
I3_CONFIG="/home/$USER/.i3/config"
YABAR_CONFIG="/home/$USER/NotreRiceANous/yabar/yabaromain.conf"

# To keep carriage return in affectation
IFS=""
# List of networks
NETWORKS=$(nmcli --fields SSID,SIGNAL dev wifi list | sed '/^--/d')
echo $NETWORKS
NETWORKS=$(echo $NETWORKS | tail -n +2)
echo $NETWORKS
NETWORKS=$(echo $NETWORKS | \
    while read LINE; do
        SIGNAL=$(echo $LINE | sed -r "s/(.* )([0-9]+)([^0-9]+)/\2/")
        SIGNAL=" $SIGNAL%"
        LINE=$(echo $LINE | sed -r "s/(.* )([0-9]+)([^0-9]+)/\1${SIGNAL}/")
        echo $LINE
    done)
echo $NETWORKS

# Dynamically change the height of the rofi menu
LINE_NUM=$(echo "$NETWORKS" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWN_CON=$(nmcli connection show)
# Really janky way of telling if there is currently a connection
CON_STATE=$(nmcli -fields WIFI g)

# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINE_NUM" -gt 8 ]; then
	LINE_NUM=8
fi

# Font params of yabar
FONT_CONFIG=$(cat $YABAR_CONFIG | grep "font:")
FONT_NAME=$(echo $FONT_CONFIG | sed -r 's/^.*font: "([^,]+),.*$/\1/g')
FONT_SIZE=$(echo $FONT_CONFIG | sed -r 's/^.* ([0-9]+)";.*$/\1/g')

# Width of rofi
#WIDTH=${YABAR_BLOCK_WIDTH}
WIDTH=$(echo $NETWORKS | \
    while read LINE; do
        CHARACS=$(echo $LINE | head -n 1 | sed 's/ //g')
        echo "${#CHARACS}"
    done)
WIDTH=$(echo $WIDTH | sort -nr -k1 | head -n 1)
# Depends a lot on the font used
WIDTH=$(($WIDTH))
PIX_WIDTH=$(echo "$WIDTH*$FONT_SIZE" | bc)

# Menu position
X=$((${YABAR_BLOCK_X}+${YABAR_BLOCK_WIDTH}-$PIX_WIDTH))
Y=${YABAR_BLOCK_Y}
if [ -f $I3_CONFIG ]; then
    Y=$(($Y+$(cat $I3_CONFIG | grep "gaps inner" | sed 's/gaps inner //')+$(cat $I3_CONFIG | grep "gaps outer" | sed 's/gaps outer //')))
fi

# Generating Xresources
echo -e "rofi.font:              $FONT_NAME $FONT_SIZE\n
         rofi.fullscreen:        false\n
         rofi.cycle:             false\n
         rofi.click-to-exit:     false\n
         rofi.separator-style:   solid\n
         rofi.location:          1\n
         rofi.yoffset:           $Y\n
         rofi.xoffset:           $X\n
         rofi.line-margin:       10\n
         rofi.padding:           5\n
         rofi.width:             $WIDTH\n
         rofi.lines:             $LINE_NUM" > "$CONFIG_PATH"

CURR_SSID=$(iwgetid -r)

# To highlight the current connection
if [[ -n $CURR_SSID ]]; then
	HIGHLINE=$(echo  "$(echo "$NETWORKS" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURR_SSID" | awk -F ":" '{print $1}') + 1" | bc )
fi

if [[ "$CON_STATE" =~ "disabled" ]] || [[ "$CON_STATE" =~ "désactivé" ]]; then
	TOGGLE="Enable Wifi"
    CH_ENTRY=$(echo -e "  $TOGGLE" | rofi -dmenu -p "" -lines 1 -config "$CONFIG_PATH")
else
	TOGGLE="Disable Wifi"
    CH_ENTRY=$(echo -e "  $TOGGLE\n  Manual Entry\n$NETWORKS" | uniq -u | rofi -dmenu -p "" -a "$HIGHLINE" -config "$CONFIG_PATH")
fi

CH_SSID=$(echo "$CH_ENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CH_ENTRY" = "  Manual Entry" ] ; then
	# Manual entry of the SSID
	MSSID=$(echo "Please enter the network SSID." | rofi -dmenu -p "" -lines 1 -config "$CONFIG_PATH")
    # Check if we know it
	if [ $(echo "$KNOWN_CON" | grep "$MSSID") = *"$MSSID"* ]; then
        RESULT=$(nmcli con up "$MSSID")
    else
        # Password
        NOPASSWD=$(nmcli dev wifi con "$MSSID")
        if [[ "$NOPASSWD" =~ "Error" ]]  || [[ "$NOPASSWD" =~ "Erreur" ]]; then
            MPASS=$(echo "Please enter the password for "$MSSID"." | rofi -dmenu -p "" -lines 1 -password -config "$CONFIG_PATH")
            RESULT=$(nmcli dev wifi con "$MSSID" password "$MPASS")
        fi
    fi

elif [ "$CH_ENTRY" = "  Enable Wifi" ]; then
	nmcli radio wifi on
    exit 0

elif [ "$CH_ENTRY" = "  Disable Wifi" ]; then
	nmcli radio wifi off
    exit 0

else
    if [ "$CH_ENTRY" = "" ]; then
        exit 0
    fi

	if [ "$CH_SSID" = "*" ]; then
		CH_SSID=$(echo "$CH_ENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWN_CON" | grep "$CH_SSID") =~ "$CH_SSID" ]]; then
        RESULT=$(nmcli con up "$CH_SSID")
	else
        CH_SECURITY=$(nmcli dev wifi | grep "$CH_SSID")
        if [[ "$CH_SECURITY" =~ "WPA2" ]] || [[ "$CH_SECURITY" =~ "WEP" ]]; then
			WIFI_PASS=$(echo "Enter password for $CH_SSID." | rofi -dmenu -p "Password: " -lines 1 -password -config "$CONFIG_PATH")
		fi
        RESULT=$(nmcli dev wifi con "$CH_SSID" password "$WIFI_PASS")
	fi

fi

if [[ "$RESULT" =~ "Erreur" ]] || [[ "$RESULT" =~ "Error" ]]; then
    echo "" | rofi -dmenu -p "Failed to connect" -lines 0 -config "$CONFIG_PATH"
fi
