#!/bin/bash
set program Visual Studio Code EPuck 2
set origin_path $PWD

quitFunc() {
    cd $origin_path
    read -p "Press any key to quit ..."
    exit
}

copyFunc() {
    cp -r vscode_epuck2/ $InstallPath
}

echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo \*\* Welcome to Visual Studio Code EPuck 2 installer \*\*
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo
echo Released in 2022
echo

echo Proceed with the installation ?
read -p "Enter y for Yes or n for No: " ans
if [ $ans != y ]
then
    quitFunc
fi

echo Make sure there are now space in your installation path!
read -e -p "InstallPath= " -i "~/.vscode_epuck2/" InstallPath
echo $InstallPath

echo Are you sure you want it to be installed at $InstallPath ?
read -p "Enter y for Yes or n for No: " ans
if [ $ans != y ]
then
    quitFunc
fi

if [ -d "$InstallPath" ]
then
    echo $InstallPath is already existing, do you want to overwrite $InstallPath ?
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]
    then
        copyFunc
    fi
else
    copyFunc
fi


#Install extensions
cd $InstallPath
echo Installing VSCode marus25.cortex-debug extension
./VSCode-linux-x64/bin/code --install-extension marus25.cortex-debug --force
echo Installing VSCode ms-vscode.cpptools extension
./VSCode-linux-x64/bin/code --install-extension ms-vscode.cpptools --force

#Few important definitions
cd VSCode-linux-x64/data/user-data/User/
InstallPath2=${InstallPath//\//\/\/}
echo { >> settings.json
echo	"explorer.confirmDelete": false, >> settings.json
echo	"gcc_arm_path": "$InstallPath2//gcc-arm-none-eabi-7-2017-q4-major", >> settings.json
echo	"epuck_tools": "$InstallPath2//tools" >> settings.json
echo } >> settings.json

#echo Creating shortcut...
cd $InstallPath

echo Create shortcut under Desktop ? [y/n]
read -p "Enter y for Yes or n for No: " ans
if [ $ans != y ]
then
    ln -s VSCode-linux-x64/code ~/Desktop/$program
fi

echo
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo \*\* Visual Studio Code EPuck2 successfully installed! \*\*
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo

sudo adduser $USER dialout #to access serial ports