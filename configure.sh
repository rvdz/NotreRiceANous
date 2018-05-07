#/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: ./instal.sh --wallpaper <path/to/wallpaper> --yabar <config-name>"
    echo "Available yabar configs: 'yabarobin', 'yabaromain' and 'yannbar'"
    exit
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
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

I3_CONFIG=~/.config/i3/config
YABAR_DIR=~/.config/yabar

i3 () {
    mkdir -p ~/.config/i3
    echo "Setting i3"
    cp ./i3/config $I3_CONFIG
}

wallpaper () {
    # Escaping '/'
    wallpaper_path=python3 -c "print('$WALLPAPER_PATH'.replace('/', '\/'))"
    sed -i "" "s/WALLPAPER_PATH/$wallpaper_path/g" $I3_CONFIG
}


yabar () {
    echo "Setting Yabar"
    mkdir -p ~/.config
    cp -r yabar  ~/.config

    # Escaping '/'
    yabar_dir=$(python3 -c "print('$YABAR_DIR'.replace('/', '\/'))")
    sed -i "" "s/YABAR_CONFIG_FILE/$yabar_dir\/$YABAR_CONFIG_NAME/g" $I3_CONFIG
}

rofi () {
    echo "Setting Rofi"
    echo "NOT IMPLEMENTED"
}

vim () {
    echo "Setting Vim"
    ./vim/install_plugins.sh
    cp ./vim/vimrc ~/.vimrc
}

compton () {
    mkdir -p ~/.config
    cp ./compton/compton.conf ~/.config
    echo "exec compton  --config ~/.config/compton.conf -b" >> $I3_CONFIG
}

i3
wallpaper
yabar
rofi
vim
compton
