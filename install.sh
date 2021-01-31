echo " ____  _      _      ___  ____  "
echo "| __ )(_)_ __| |__  / _ \/ ___| "
echo "|  _ \| | '__| '_ \| | | \___ \ "
echo "| |_) | | |  | |_) | |_| |___) |"
echo "|____/|_|_|  |_.__/ \___/|____/ "
echo ""

echo -n "> Detecting distribution... "
distro=$(lsb_release -ds | sed 's/"//g')
echo $distro

echo -n "> Do you want to use [s]udo or [d]oas to run root commands? (S/d): "
read rootcmd
if [ -z $rootcmd ]
then
	echo "> Defaulting to sudo"
	rootcmd=sudo
else
	if [[ "$rootcmd" == "s" ]]
	then
		echo "> Using sudo"
		rootcmd=sudo
	elif [[ "$rootcmd" == "d" ]]
	then
		echo "> Using doas"
		rootcmd=doas
	else
		echo "> Invalid option. Quitting..."
		exit 0
	fi
fi


# Install packages
if [[ "$distro" == "Arch Linux" ]]
then
	echo "> Updating system"
	$rootcmd pacman -Syu --noconfirm

	echo "> Installing development packages"
	$rootcmd pacman -S --noconfirm --needed base-devel git

	echo "> Installing xorg packages"
	$rootcmd pacman -S --noconfirm --needed xorg-xrdb xorg-xset xorg-xauth xorg-xinit xorg-xkill xorg-xprop xorg-server xorg-xinput xorg-xrandr xorg-xkbcomp xorg-xmodmap xorg-xdpyinfo xorg-xmessage xorg-xsetroot xorg-setxkbmap xorg-fonts-type1 xorg-server-common xorg-fonts-encodings

	echo "> Installing cool programs"
	$rootcmd pacman -S --noconfirm --needed termite dunst sxhkd weechat rofi xorg mpv neovim zsh xdg-utils stow
fi


echo "> Installing suckless things"
mkdir ~/Programs/suckless
cd ~/Programs/suckless

# Download sources
git clone https://github.com/Toasterbirb/dwm
git clone https://github.com/Toasterbirb/surf
git clone https://github.com/Toasterbirb/dmenu
git clone https://github.com/Toasterbirb/slock

# Install them
sh ~/Programs/suckless/dwm/install.sh
sh ~/Programs/suckless/surf/install.sh
sh ~/Programs/suckless/dmenu/install.sh
sh ~/Programs/suckless/slock/install.sh

# Clone dotfiles
echo "> Installing muh dotfiles"
cd ~
git clone https://github.com/Toasterbirb/dotfiles
cd ~/dotfiles
stow -t ~

# Cleaning up .xinitrc so it doesn't contain my personal launch commands
echo "exec dwm" > ~/.xinitrc