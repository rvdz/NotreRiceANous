# Notre Rice A Nous
This project aims at configuring a linux environment in a fast and easy way.

Currently, there are dotfiles for the following targets:
- [Vim](http://www.vim.org)
- [Rofi](https://github.com/DaveDavenport/rofi)
- [Compton](https://github.com/chjj/compton)
- [i3](https://i3wm.org/) and [i3 gaps](https://github.com/Airblader/i3)
- [Yabar](https://github.com/geommer/yabar)

## Usage
### Dependencies
First, install the dependencies:

__Debian__
```bash
sudo apt install vim python3-pip git yabar rofi -y
pip3 install i3ipc
```

__Ubuntu__
```bash
sudo apt install vim python3-pip git rofi -y
pip3 install i3ipc
```
see [yabar](https://github.com/geommer/yabar) to install this target

__CentOS__
```bash
sudo yum install vim yum install python36 python36-setuptools python36-pip git
pip3 install i3ipc
```
see [yabar](https://github.com/geommer/yabar) and [Rofi](https://github.com/DaveDavenport/rofi)
to install these target

i3 gaps installation is described [here](https://github.com/Airblader/i3/wiki/Compiling-&-Installing)

## Install
Run the following command in this folder:
```bash
./install.sh
```
