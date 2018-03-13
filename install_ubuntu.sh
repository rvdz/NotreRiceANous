#/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: ./instal.sh --wallpaper <path/to/wallpaper> --yabar <config-name>"
    echo "Available yabar configs: 'Robin', 'Romain' and 'Yann'"
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -w|--wallpaper)
    WALLPAPER_PATH="$2"
    shift # past argument
    shift # past value
    ;;
    -y|--yabar)
    YABAR_CONFIG_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

CONFIG_DIR=~/.config

# Setting i3
echo "Setting i3"
I3_CONFIG=$CONFIG_DIR/i3/config
cp ./i3/config $I3_CONFIG

# Setting Wallpaper
echo "Setting Wallpaper"
echo

# Escaping '/'
WALLPAPER_PATH=$(python3 -c "print('$WALLPAPER_PATH'.replace('/', '\/'))")
WALLPAPER_TOKEN=WALLPAPER_PATH
sed -i "s/$WALLPAPER_TOKEN/$WALLPAPER_PATH/g" $I3_CONFIG

# Setting Yabar
echo "Setting Yabar"
YABAR_DIR=$CONFIG_DIR/yabar
cp -r ./yabar  $CONFIG_DIR/

# Escaping '/'
YABAR_DIR=$(python3 -c "print('$YABAR_DIR'.replace('/', '\/'))")

YABAR_CONFIG=""
if [[ $YABAR_CONFIG_NAME == "Romain" ]]; then
    YABAR_CONFIG="yabaromain.conf"
elif [[ $YABAR_CONFIG_NAME == "Robin" ]]; then
    YABAR_CONFIG="yabarobin.conf"
elif [[ $YABAR_CONFIG_NAME == "Yann" ]]; then
    YABAR_CONFIG="yannbar.conf"
fi

YABAR_TOKEN=YABAR_CONFIG
sed -i "s/$YABAR_TOKEN/$YABAR_DIR\/$YABAR_CONFIG/g" $I3_CONFIG

# Setting Rofi
echo "Setting Rofi"
cp ./rofi/.Xresources ~/

# Setting Compton
echo "Setting Compton"
mkdir $CONFIG_DIR/compton
cp ./compton/compton.conf $CONFIG_DIR/compton/

# Setting Vim
echo "Setting Vim"
# ./vim/install_plugins.sh
# cp ./vim/vimrc ~/.vimrc
