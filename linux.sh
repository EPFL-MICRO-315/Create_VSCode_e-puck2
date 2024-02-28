#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
	
line1='export PYENV_ROOT="$HOME/.pyenv"' #for .bashrc, .profile, .bash_profile
line2='command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' #for .bashrc, .profile
line4='[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' #for .bash_profile
line3='eval "$(pyenv init -)"' #for .bashrc, .profile, .bash_profile
PACKAGES="git make build-essential libssl-dev zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev wget curl llvm libncurses5-dev python3-tk liblzma-dev libmtdev-dev libglib2.0-dev libnss3-dev libatk1.0-dev libatk-bridge2.0-dev libgtk-3-dev libasound-dev python3-tk libxcb-xinerama0"
os=$(eval grep "^ID=" /etc/os-release | cut -d"=" -f2)

function install() {
	echo -e "${GREEN}Installing required packages${NC}"

	if [ "$os" = "fedora" ]; then
		sudo dnf install -y git make gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel dpkg
	elif [[ "$os" = "ubuntu" || "$os" = "pop" ]]; then
		sudo apt-get update
		sudo apt-get install -y $PACKAGES
	fi


	if ! command -v pyenv &> /dev/null
	then
		echo -e "${GREEN}pyenv not found, installing${NC}" 
		curl https://pyenv.run | bash

		echo -e "${GREEN}Configuring pyenv, adding to path (.bashrc, .profile, .bash_profile)${NC}"
		if ! grep -q -e "$line1" -e "$line2" -e "$line3" ~/.bashrc; then
			echo "$line1" >> ~/.bashrc
			echo "$line2" >> ~/.bashrc
			echo "$line3" >> ~/.bashrc
		fi

		if ! grep -q -e "$line1" -e "$line2" -e "$line3" ~/.profile; then
			echo "$line1" >> ~/.profile
			echo "$line2" >> ~/.profile
			echo "$line3" >> ~/.profile
		fi

		if ! grep -q -e "$line1" -e "$line4" -e "$line3" ~/.bash_profile; then
			echo "$line1" >> ~/.bash_profile
			echo "$line4" >> ~/.bash_profile
			echo "$line3" >> ~/.bash_profile
		fi
	else
		echo -e "${GREEN}pyenv already installed${NC}"
	fi

	echo -e "${GREEN}Reloading the shell${NC}"
	source ~/.bashrc
	source ~/.profile
	source ~/.bash_profile

	echo -e "${GREEN}Installing python 3.11.2${NC}"
	pyenv install -s 3.11.2
	pyenv virtualenv 3.11.2 e-puck2
	pyenv local e-puck2

	echo -e "${GREEN}Installing packages required for installation${NC}"
	pip install --upgrade pip
	pip install PyQt5
	pip install requests distro
	echo -e "${GREEN}Launching the installer${NC}"
	python Universal/main.py install
}

function uninstall() {
	echo -e "${GREEN}Launching wizard${NC}"
	python Universal/main.py uninstall

	echo -e "${GREEN}Do you want to uninstall pyenv? (yes/no)${NC}"
    read response
    if [ "$response" = "yes" ]; then
        echo -e "${GREEN}Uninstalling pyenv and related packages${NC}"
        rm -rf ~/.pyenv

        # remove the lines from .bashrc, .profile, .bash_profile
        sed -i "/${line1//\//\\/}/d" ~/.bashrc
        sed -i "/${line2//\//\\/}/d" ~/.bashrc
        sed -i "/${line3//\//\\/}/d" ~/.bashrc

        sed -i "/${line1//\//\\/}/d" ~/.profile
        sed -i "/${line2//\//\\/}/d" ~/.profile
        sed -i "/${line3//\//\\/}/d" ~/.profile

		sed -i "/${line1//\//\\/}/d" ~/.bash_profile
        sed -i "/${line4//\//\\/}/d" ~/.bash_profile
        sed -i "/${line3//\//\\/}/d" ~/.bash_profile
    else
        echo -e "${GREEN}Skipping pyenv uninstallation${NC}"
    fi
	
	if [[ "$os" = "ubuntu" || "$os" = "pop" ]]; then
		for package in $PACKAGES; do
		if apt-cache rdepends $package | grep -q "^ "; then
			echo "$package is a dependency of another package, not removing"
		else
			echo "${GREEN}Removing $package${NC}"
			sudo apt-get remove -y $package
		fi
		done
	fi
}

echo -e "${GREEN}The script should be run within the Create_VSCode_e-puck2-RefTag directory!${NC}"
if [ "$os" = "fedora" ]; then
	echo -e "${GREEN}Running on Fedora${NC}"
elif [[ "$os" = "ubuntu" || "$os" = "pop" ]]; then
	echo -e "${GREEN}Running on Ubuntu based distro${NC}"
else
	echo -e "${GREEN}Running on Unknown distribution, hazardeous!${NC}"
fi

case "$1" in
    uninstall)
        uninstall
        ;;
    install)
        install
        ;;
    help)
		echo -e "This installer script is tested on Fedora, Ubuntu and Pop!_OS."
		echo -e "It should works on most debian based distributions as well (you might need to edit line 18 of the linux.sh script)"
		echo -e "In case the script is not working on your host (e.g: Nixos, Archlinux), we invite you to use Distrobox"
		echo -e "\nUse 'install' or 'uninstall'"
		;;
	*)
        echo -e "${GREEN}Invalid argument. Use 'install' or 'uninstall'${NC}"
        ;;
esac