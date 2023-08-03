@echo off
py -3 --version

if errorlevel 0 goto proceed
echo "No python version >= 3 detected!"
echo "Aborting!"
exit

:proceed
echo "python version >= 3 detected!"
echo "proceeding with pre-installation"
py -3 -m pip install --upgrade pip
py -3 -m pip install colorama
py -3 -m pip install termcolor
py -3 -m pip install "kivy[base]"
py -3 Universal/main.py