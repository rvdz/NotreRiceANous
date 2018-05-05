#!/bin/bash
# Ubuntu Xenial and Debian Strech

function essentials {
    apt update
    apt install -y git python-pip python3-pip curl build-essentials feh compton
}

function i3_gaps {
    apt update
    if [[ $(lsb_release -a) == "Ubuntu" ]]; then
        apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
                    libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev \
                    libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
                    libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf \
                    libxcb-xrm-dev
    elif [[ $(lsb_release -a) == "Debian" ]]; then
        apt install -y libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb \
                    libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev \
                    libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev \
                    libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev \
                    libxcb-xrm0 libxcb-xrm-dev
    fi

    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    make install
    cd ..
}

function i3 {
    if [[ $(uname -a) == "Ubuntu" ]]; then
        /usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2018.01.30_all.deb keyring.deb SHA256:baa43dbbd7232ea2b5444cae238d53bebb9d34601cc000e82f11111b1889078a
        dpkg -i ./keyring.deb
        echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list
    elif [[ $(uname -a) == "Debian" ]]; then
        $ /usr/lib/apt/apt-helper download-file http://dl.bintray.com/i3/i3-autobuild/pool/main/i/i3-autobuild-keyring/i3-autobuild-keyring_2016.10.01_all.deb keyring.deb SHA256:460e8c7f67a6ae7c3996cc8a5915548fe2fee9637b1653353ec62b954978d844
        apt install ./keyring.deb
        echo 'deb http://dl.bintray.com/i3/i3-autobuild sid main' > /etc/apt/sources.list.d/i3-autobuild.list
    fi
    apt update
    apt install i3
}

function yabar {
    apt install -y libcairo2-dev libpango1.0-dev libconfig-dev libxcb-randr0-dev \
                libxcb-ewmh-dev libxcb-icccm4-dev libgdk-pixbuf2.0-dev libasound2-dev \
                libiw-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-xkb-dev
    git clone https://github.com/geommer/yabar.git
    cd yabar
    make yabar
    make install
    cd ..
}

function rofi {
    apt update
    apt install -y autoconf automake flex
    apt install -y libpango libpangocairo libcairo-xcb libglib librsvg2.0 \
                   libstartup-notification-1.0 libxkbcommon libxkbcommon-x11 \
                   libxcb xcb-util xcb-util-wm

    curl https://github.com/Airblader/xcb-util-xrm/releases/download/v1.3/xcb-util-xrm-1.3.tar.gz
    tar -zxf xcb-util-xrm-1.3.tar.gz
    cd xcb-util-xrm-1.3
    ./autogen.sh
    ./configure
    make
    make install
    cd ..

    # Bison parser
    # curl http://mirror.ibcp.fr/pub/gnu/bison/bison-1.25.tar.gz
    # tar -xvf bison-1.25.tar.gz
    # cd bison-1.25
    # ./configure
    # make
    # make install

    curl https://github.com/DaveDavenport/rofi/releases/download/1.5.1/rofi-1.5.1.tar.gz
    tar -xvf rofi-1.5.1.tar.gz
    cd rofi-1.5.1
    ./configure
    make
    make install
    cd ..
}

function yabar_utils {
    pip install i3ipc
}

essentials
i3
i3_gaps
yabar_utils
yabar
rofi
