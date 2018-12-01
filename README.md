# Notre Rice A Nous
This project aims at providing a tool that automatically installs and
configures a linux environment as it should be.

Currently, there are dotfiles for the following targets:
- [Vim](http://www.vim.org)
- [Rofi](https://github.com/DaveDavenport/rofi)
- [Compton](https://github.com/chjj/compton)
- [i3](https://i3wm.org/) and [i3 gaps](https://github.com/Airblader/i3)
- [Yabar](https://github.com/geommer/yabar)

## Usage
The install script is currently only compatible with Debian or Ubuntu.
This script allows you to install the main targets through a single entry point,
for instance, if you want to install `i3`, just run `sudo ./install.sh --i3`.

```sh
Usage:
    install.sh [--i3] [--yabar] [--rofi] [--zsh] [--compton] [--all]
```

Once you have installed your targets, we created a script to help
you configure them. What it will do is:
- Add i3's config to `~/.config/i3/config`
- Add yabar custom scripts and configs in `~/.config/yabar`
- Install some useful vim plugins
- Add compton support into i3's config

```sh
./configure.sh
```

# Additional Tools

## Oh My Zsh
- [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

## i3
- [i3lock-fancy](https://github.com/meskarune/i3lock-fancy.git)

## Yabar
In addition of yabar's base scripts, we added some more:
- Battery level
- Brightness level
- CPU temperature
- Title and artist of the current audio track
- Volume level
- Icon of the current workspace
- Ping
- Network status
