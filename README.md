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

__Ubuntu__
```bash
sudo apt update
sudo apt install vim python3 fonts-font-awesome compton feh python3-pip python python-pip git rofi -y
pip install i3ipc
```

## Install
Run the following command in this folder:
```bash
./install_ubuntu.sh --wallpaper <path/to/wallpaper> --yabar <config_name>
```

# Additional Tools
## Oh My Zsh
- [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

## i3
- [i3lock-fancy](https://github.com/meskarune/i3lock-fancy.git)
