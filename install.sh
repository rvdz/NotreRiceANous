#/bin/bash
# Setting i3
echo "Setting i3"
i3_config=~/.config/i3/config
cp ./i3/config $i3_config

# Setting Wallpaper
echo "Setting Wallpaper"
echo "Enter the wallpaper's absolute path: "
read wallpaper_path
echo

# Escaping '/'
wallpaper_path=python3 -c "print('$wallpaper_path'.replace('/', '\/'))"
wallpaper_token=WALLPAPER_PATH
sed -i "" "s/$wallpaper_token/$wallpaper_path/g" $i3_config

# Setting Yabar
echo "Setting Yabar"
yabar_dir=~/.config/yabar
cp -r yabar  ~/.config
cp -r script $yabar_dir

echo "Choose a yabar's config: 'Romain', 'Robin' or 'Yann': "
read config_name
echo

# Escaping '/'
yabar_dir=python3 -c "print('$yabar_dir'.replace('/', '\/'))"

yabar_config=""
if [[ $config_name == "Romain" ]]; then
    yabar_config="yabaromain.conf"
else if [[ $config_name == "Robin" ]]; then
    yabar_config="yabarobin.conf"
fi

yabar_token=YABAR_CONFIG_FILE
sed -i "" "s/$yabar_token/$yabar_dir\/$yabar_config/g" $i3_config

# Setting Rofi
echo "Setting Rofi"
echo "NOT IMPLEMENTED"

# Setting Compton
echo "Setting Compton"
echo "NOT IMPLEMENTED"

# Setting Vim
echo "Setting Vim"
./vim/install_plugins.sh
cp ./vim/vimrc ~/.vimrc
