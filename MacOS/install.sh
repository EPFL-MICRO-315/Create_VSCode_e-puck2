#!/bin/bash
programVS=VSCode_EPuck2.app
data="code-portable-data"
programGCC=gcc-arm-none-eabi-7-2017-q4-major
programTools=EPuckTools
programUtils=Utils
origin_path=$PWD

quitFunc() {
    cd $origin_path
    read -p "Press any key to quit ..."
    exit
}

programVSFunc() {
    echo
    echo "Download VSCode"
    curl -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" --output vscode.zip

    echo
    echo "Extracting vscode.zip"
    unzip -q vscode.zip
    rm vscode.zip
    mv "Visual Studio Code.app" $InstallPath/$programVS
}

dataFunc() {
    echo
    echo "Enabling VSCode portable mode"
    mkdir $InstallPath/$data #enable portable mode
    cp -r Utils $InstallPath/$programTools/
}

programGCCFunc() {
    echo
    echo "Download gcc-arm-none-eabi"
    curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2" --output "gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"

    echo
    echo "Extracting gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
    tar -xf gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
    rm gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
    mkdir $InstallPath/$programTools
    mv gcc-arm-none-eabi-7-2017-q4-major $InstallPath/$programTools/$programGCC
}

echo "*****************************************************"
echo "** Welcome to Visual Studio Code EPuck 2 installer **"
echo "*****************************************************"
echo
echo "see https://github.com/epfl-mobots/Create_VSCode_e-puck2"
echo "Released in 2022"
echo

echo "Proceed with the installation ?"
read -p "Enter y for Yes or any word for No: " ans
if [ $ans != y ]; then
    quitFunc
fi

echo
echo "Installation of Homebrew required to install several utility programs"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo
echo "Installation of wget required to download vscode and compiler"
brew install wget

echo
echo "Installation of dfu-util"
brew install dfu-util

echo
echo "Installation of git and git-crendential-manager-core"
brew install git
brew tap microsoft/git
brew install --cask git-credential-manager-core

ans=n
while [ $ans != y ]; do
    echo
    read -p "InstallPath by default is ~/Applications" InstallPath
    InstallPath=${InstallPath:-~/Applications}
    echo
    echo "Are you sure you want it to be installed at $InstallPath ?"
    read -p "Enter y for Yes, any word for No: " ans
done

if [ -d "$InstallPath/$programVS" ]; then 
    echo "$InstallPath/$programVS is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        rm -rf $InstallPath/$programVS
        programVSFunc
    fi
else
    programVSFunc
fi

if [ -d "$InstallPath/$data" ]; then 
    echo "$InstallPath/$data is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        rm -rf $InstallPath/$data
        dataFunc
    fi
else
    dataFunc
fi

if [ -d "$InstallPath/$programTools/$programGCC" ]; then 
    echo "$InstallPath/$programTools/$programGCC is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        rm -rf $InstallPath/$programTools/$programGCC
        programGCCFunc
    fi
else
    programGCCFunc
fi

#Install extensions
cd $InstallPath/$programVS/Contents/Resources/app/bin
echo
echo "Installing VSCode marus25.cortex-debug extension"
./code --install-extension marus25.cortex-debug --force
echo
echo "Installing VSCode ms-vscode.cpptools extension"
./code --install-extension ms-vscode.cpptools --force

#Workplace
echo
echo "Select the workplace where you will be working on"
echo "Make sure there are no spaces in your workingplace!"
read -p "Workplace by default is ~/Documents/EPuck2" Workplace
Workplace=${Workplace:-~/Documents/Workplace}
echo
echo "Are you sure you want your workplace to be at $Workplace ?"
read -p "Enter y for Yes or n for No: " ans
while [ $ans != y ]; do
    echo
    read -p "Workplace by default is ~/Documents/EPuck2" Workplace
    Workplace=${Workplace:-~/Documents/Workplace}
done
mkdir $Workplace
cd $Workplace
echo 
echo "Cloning the libraries into the workplace"
git clone https://github.com/epfl-mobots/Lib_VSCode_e-puck2.git

#Important VSCode settings definitions
echo
echo "Configuring vscode..."
cd $InstallPath/$data/user-data/User/
SettingsPath=${InstallPath//\//\/\/}
echo "{" >> settings.json
#Path used by intellissense to locate lib source files
echo "	\"gcc_arm_path\": \"$SettingsPath//$programTools//gcc-arm-none-eabi-7-2017-q4-major\"," >> settings.json
#Path used for debuging (.svd), dfu
echo "	\"epuck_tools\": \"$SettingsPath//$programTools/Utils\"," >> settings.json
echo "	\"workplace\": \"$Workplace\"," >> settings.json
echo "	\"terminal.integrated.env.osx\": {" >> settings.json
echo "	    \"PATH\": \"\$PATH:$SettingsPath//$programTools//gcc-arm-none-eabi-7-2017-q4-major//bin\"" >> settings.json
echo "  }" >> settings.json
echo "}" >> settings.json

echo
echo "Adding dfu task to user level"
cp $origin_path/tasks.json tasks.json

echo
echo "*******************************************************"
echo "** Visual Studio Code EPuck2 successfully installed! **"
echo "*******************************************************"
echo

quitFunc