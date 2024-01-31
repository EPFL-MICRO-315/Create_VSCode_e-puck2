#!/bin/zsh

GREEN='\033[0;32m'
NC='\033[0m' # No Color
	
line1='export PYENV_ROOT="$HOME/.pyenv"' #for .bashrc, .profile, .bash_profile
line2='command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' #for .bashrc, .profile
line3='eval "$(pyenv init -)"' #for .bashrc, .profile, .bash_profile

function install() {
	echo -e "${GREEN}Installing required packages${NC}"

	if ! command -v brew &> /dev/null
	then
		echo -e "${GREEN}brew not found, installing${NC}"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi	
	echo -e "${GREEN}updating brew${NC}"
	brew update

	if ! command -v pyenv &> /dev/null
	then
		echo -e "${GREEN}pyenv not found, installing${NC}" 
		brew install pyenv
	else
		echo -e "${GREEN}pyenv already installed${NC}"
	fi

	echo -e "${GREEN}Configuring pyenv, adding to path (.zshrc)${NC}"
	if ! grep -q -e "$line1" -e "$line2" -e "$line3" ~/.bashrc; then
		echo "$line1" >> ~/.bashrc
		echo "$line2" >> ~/.bashrc
		echo "$line3" >> ~/.bashrc
	fi
	
	echo -e "${GREEN}Reloading the shell${NC}"
	source ~/.zshrc

	echo -e "${GREEN}Installing python 3.11.2${NC}"
	pyenv install -s 3.11.2
	pyenv local 3.11.2

	echo -e "${GREEN}Installing packages required for installation${NC}"
	pip install --upgrade pip
	pip install PyQt5
	pip install requests

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

        # remove the lines from .zshrc
        sed -i "/${line1//\//\\/}/d" ~/.zshrc
        sed -i "/${line2//\//\\/}/d" ~/.zshrc
        sed -i "/${line3//\//\\/}/d" ~/.zshrc
    else
        echo -e "${GREEN}Skipping pyenv uninstallation${NC}"
    fi
}

echo -e "${GREEN}The script should be run within the Create_VSCode_e-puck2 directory!${NC}"
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
		echo -e "This installer script is made for MacOS"
		echo -e "It should works on most MacOS version, it was tested on Ventura" #TODO: add version
		echo -e "\nUse 'install' or 'uninstall'"
		;;
	*)
        echo -e "${GREEN}Invalid argument. Use 'install' or 'uninstall'${NC}"
        ;;
esac