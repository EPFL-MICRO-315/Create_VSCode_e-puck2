echo "Installing pyenv if not already installed"
curl https://pyenv.run | bash

echo "Installing python 3.11.2"
pyenv install 3.11.2
pyenv local 3.11.2

echo "Installing packages required for installation"
pip install --upgrade pip
pip install colorama
pip install termcolor
pip install "kivy[base]"

echo "Launching the installer"
python Universal/main.py
