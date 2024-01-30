#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
	
line1='export PYENV_ROOT="$HOME/.pyenv"' #for .bashrc, .profile, .bash_profile
line2='command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' #for .bashrc, .profile
line4='[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' #for .bash_profile
line3='eval "$(pyenv init -)"' #for .bashrc, .profile, .bash_profile

function install() {
	echo -e "${GREEN}Installing required packages${NC}"
	sudo apt-get update
	sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev wget curl llvm libncurses5-dev python3-tk liblzma-dev libmtdev-dev libglib2.0-dev libnss3-dev libatk1.0-dev libatk-bridge2.0-dev libgtk-3-dev libasound-dev

	if ! command -v pyenv &> /dev/null
	then
		echo -e "${GREEN}pyenv not found, installing${NC}" 
		curl https://pyenv.run | bash
	else
		echo -e "${GREEN}pyenv already installed${NC}"
	fi

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

	echo -e "${GREEN}Reloading the shell${NC}"
	source ~/.bashrc

	echo -e "${GREEN}Installing python 3.11.2${NC}"
	LDFLAGS="-L/nix/store/j0pi1a69r7zzwxl92c21w1l2syyfnchp-zlib-1.3/lib" pyenv install -s 3.11.2
	pyenv local 3.11.2

	echo -e "${GREEN}Installing packages required for installation${NC}"
	pip install --upgrade pip
	pip install PyQt5
	echo -e "${GREEN}Launching the installer${NC}"
	python Universal/main.py
}

function uninstall() {
	echo -e "${GREEN}Uninstalling of VSCode-Epuck2 not yet implemented${NC}"

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
}

case "$1" in
    uninstall)
        uninstall
        ;;
    install)
        install
        ;;
	debug)
		python Universal/main.py
		;;
    help)
		echo -e "This installer script is made for Ubuntu"
		echo -e "It should works on most debian based distributions as well"
		echo -e "In case the script is not working on your host (e.g: Nixos, Archlinux), we invite you to use Distrobox"
		echo -e "\nUse 'install' or 'uninstall'"
		;;
	*)
        echo -e "${GREEN}Invalid argument. Use 'install' or 'uninstall'${NC}"
        ;;
esac