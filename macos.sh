#!/bin/bash

#####################################################
##              BEGINNING OF SCRIPT               ##
#####################################################

InstallerPath=$(dirname "$0")

# If the script is runned from its folder, the folder name will be "." and all "cd" inside the script will be the reference "."
if [ "$InstallerPath" == "." ]; then
    InstallerPath=$(pwd)
fi

GREEN='\033[0;32m'
NC='\033[0m' # No Color
	
line1='export PYENV_ROOT="$HOME/.pyenv"'
line2='command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
line3='eval "$(pyenv init -)"'
line4='eval "$(pyenv virtualenv-init -)"'

function install() {
	echo -e "${GREEN}Installing required packages${NC}"

	# Detect the system architecture (arm64 for Apple Silicon, otherwise assume Intel)
	ARCH=$(uname -m)
	if [[ "$ARCH" == "arm64" ]]; then
		BREW_BIN="/opt/homebrew/bin/brew"
		BREW_SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
	else
		BREW_BIN="/usr/local/bin/brew"
		BREW_SHELLENV='eval "$(/usr/local/bin/brew shellenv)"'
	fi

	# If brew is not installed, install it and update the current shell environment
	if ! command -v brew &> /dev/null; then
		echo -e "${GREEN}brew not found, installing...${NC}"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
		
		# Append the appropriate brew shellenv command to the user's shell profile
		# Adjust the file if you use bash (e.g. ~/.bash_profile) instead of zsh.
		if [[ "$ARCH" == "arm64" ]]; then
			(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
		else
			(echo; echo 'eval "$(/usr/local/bin/brew shellenv)"') >> "$HOME/.zprofile"
		fi

		# Update the PATH for the current shell session
		eval "$BREW_SHELLENV"
	fi

	echo -e "${GREEN}Updating brew...${NC}"
	# Use the full path to brew to ensure it's recognized
	"$BREW_BIN" update

	if ! command -v pyenv &> /dev/null
	then
		echo -e "${GREEN}pyenv not found, installing${NC}" 
		brew install pyenv
		brew install pyenv-virtualenv
		echo -e "${GREEN}Configuring pyenv and pyenv-virtualenv, adding to path (.zshrc)${NC}"
		if ! grep -q -e "$line1" -e "$line2" -e "$line3" -e "$line4" ~/.zshrc; then
			echo "$line1" >> ~/.zshrc
			echo "$line2" >> ~/.zshrc
			echo "$line3" >> ~/.zshrc
			echo "$line4" >> ~/.zshrc
		fi
	else
		echo -e "${GREEN}pyenv already installed${NC}"
	fi
	
	echo -e "${GREEN}Reloading the shell${NC}"
	source ~/.zshrc

	echo -e "${GREEN}Installing python 3.11.2${NC}"
	pyenv install -s 3.11.2
	pyenv virtualenv 3.11.2 e-puck2
	cd $InstallerPath
	pyenv local e-puck2

	echo -e "${GREEN}Installing packages required for installation${NC}"
	python -m ensurepip --upgrade
	python -m pip install --upgrade pip
	python -m pip install PyQT5 termcolor requests distro

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
        # remove the lines from .zshrc
        sed -i '' "/${line1//\//\\/}/d" ~/.zshrc
        sed -i '' "/${line2//\//\\/}/d" ~/.zshrc
        sed -i '' "/${line3//\//\\/}/d" ~/.zshrc
        sed -i '' "/${line4//\//\\/}/d" ~/.zshrc
        brew uninstall pyenv-virtualenv
        brew uninstall pyenv
		rm -rf $HOME/.pyenv
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
    help)
		echo -e "This installer script is made for MacOS"
		echo -e "It should works on most MacOS version, it was tested on Ventura" #TODO: add version
		echo -e "\nUse 'install' or 'uninstall'"
		;;
	*)
        echo -e "${GREEN}Invalid argument. Use 'install' or 'uninstall'${NC}"
        ;;
esac