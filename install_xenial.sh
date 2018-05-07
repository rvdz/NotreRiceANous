#!/bin/bash
# Ubuntu Xenial and Debian Strech

BASE=~/dev

essentials () {
    mkdir -p $BASE
    apt update
    apt install -y git python-pip python3-pip curl build-essential feh compton wget autoconf
}

i3 () {
    /usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2018.01.30_all.deb keyring.deb SHA256:baa43dbbd7232ea2b5444cae238d53bebb9d34601cc000e82f11111b1889078a
    dpkg -i ./keyring.deb
    echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list

    apt update
    apt install -y i3
}

i3_gaps () {
    apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
                libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
                libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
                libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev

    # xcb-util-xrm
    cd $BASE
    wget https://github.com/Airblader/xcb-util-xrm/releases/download/v1.3/xcb-util-xrm-1.3.tar.gz
    tar -zxf xcb-util-xrm-1.3.tar.gz
    cd ./xcb-util-xrm-1.3
    ./configure
    make
    make install
    cd ../

    # i3-gaps
    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd ./i3-gaps
    autoreconf --force --install
    rm -rf build/
    mkdir -p build
    cd build
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers

    make
    make install
}

yabar () {
    apt install -y libcairo2-dev libpango1.0-dev libconfig-dev libxcb-randr0-dev \
                    libxcb-ewmh-dev libxcb-icccm4-dev libgdk-pixbuf2.0-dev libasound2-dev \
                    libiw-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-xkb-dev
    cd $BASE
    git clone https://github.com/geommer/yabar.git
    cd ./yabar

    make yabar
    # Remove doc creation (requires latex)
    sed -i "/\b\(MANPREFIX\)\b/d" Makefile
    make install
}

rofi () {
    apt install -y autoconf automake flex xcb libpango1.0-dev \
                libpangocairo-1.0-0 librsvg2-dev libstartup-notification0-dev \
                libxkbcommon-dev libxkbcommon-x11-dev

    cd $BASE
    # Bison parser
    wget http://mirror.ibcp.fr/pub/gnu/bison/bison-1.25.tar.gz
    tar -xvf bison-1.25.tar.gz
    cd ./bison-1.25
    ./configure
    make
    make install
    cd ../

    # Check >= 0.11
    wget https://github.com/libcheck/check/releases/download/0.12.0/check-0.12.0.tar.gz
    tar -zxf check-0.12.0.tar.gz
    cd ./check-0.12.0
    ./configure
    make
    make install
    cd ../

    # Rofi
    wget https://github.com/DaveDavenport/rofi/releases/download/1.5.1/rofi-1.5.1.tar.gz
    tar -xvf rofi-1.5.1.tar.gz
    cd ./rofi-1.5.1
    ./configure
    make
    make install
}

yabar_utils () {
    apt install -y amixer
    pip install i3ipc
}

zsh () {
    apt install -y zsh
    cd $BASE
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "Please add 'zsh-autosuggestions' and 'zsh-syntax-highlighting' to your .zshrc"
}

essentials
i3
i3_gaps
yabar
rofi
yabar_utils
zsh
