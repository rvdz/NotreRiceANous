#/bin/bash

I3_CONFIG=~/.config/i3/config
YABAR_DIR=~/.config/yabar

i3 () {
    mkdir -p ~/.config/i3
    echo "Setting i3"
    cp ./i3/config $I3_CONFIG
}

yabar () {
    echo "Setting Yabar"
    mkdir -p ~/.config
    cp -r yabar  ~/.config
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
yabar
vim
compton
