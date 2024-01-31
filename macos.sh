#!/bin/zsh
if ! command -v brew &> /dev/null
then
	echo "brew not found, installing"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi	
echo "updating brew"
brew update

if ! command -v pyenv &> /dev/null
then
	echo "pyenv not found, installing" 
	brew install pyenv
else
	echo "pyenv already installed"
fi

echo "Configuring pyenv"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

echo "reloading the shell"
source ~/.zshrc

echo "Installing python 3.11.2"
pyenv install -s 3.11.2
pyenv local 3.11.2

echo "Installing packages required for installation"
pip install --upgrade pip
pip install requests
pip install PyQt5

echo "Launching the installer"
python Universal/main.py
