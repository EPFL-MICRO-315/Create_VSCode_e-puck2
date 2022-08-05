#!/bin/bash
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
    mv "Visual Studio Code.app" $InstallPath/VSCode_EPuck2.app
}

EPuck2ToolsFunc() {
    echo
    echo "Download gcc-arm-none-eabi"
    curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2" --output "gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"

    echo
    echo "Extracting gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
    tar -xf gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
    rm gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
    mkdir -p $InstallPath/EPuck2Tools
    mv gcc-arm-none-eabi-7-2017-q4-major $InstallPath/EPuck2Tools/

    cp -r Utils $InstallPath/EPuck2Tools/Utils
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

#####################################################
##              Select Install Path                ##
#####################################################
ans=n
while [ $ans != y ]; do
    echo
    read -p "InstallPath by default is ~/Applications" InstallPath
    InstallPath=${InstallPath:-~/Applications}
    echo
    echo "Are you sure you want it to be installed at $InstallPath ?"
    read -p "Enter y for Yes, any word for No: " ans
done
mkdir -p $InstallPath #making sure this folder exists

#####################################################
##                Install VSCode                   ##
#####################################################
if [ -d "$InstallPath/VSCode_EPuck2.app" ]; then 
    echo "$InstallPath/VSCode_EPuck2.app is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        rm -rf $InstallPath/VSCode_EPuck2.app
        programVSFunc
    fi
else
    programVSFunc
fi

#####################################################
##            Install GCC-ARM-NONE-EABI            ##
#####################################################
if [ -d "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major" ]; then 
    echo "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        rm -rf $InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major
        EPuck2ToolsFunc
    fi
else
    EPuck2ToolsFunc
fi

#####################################################
##               Enable Portable Mode              ##
#####################################################
if [ -d "$InstallPath/code-portable-data" ]; then 
    echo "$InstallPath/code-portable-data is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        rm -rf $InstallPath/code-portable-data
        echo
        echo "Enabling VSCode portable mode"
        mkdir $InstallPath/code-portable-data
    fi
else
    echo
    echo "Enabling VSCode portable mode"
    mkdir $InstallPath/code-portable-data
fi

#####################################################
##              Install extensions                 ##
#####################################################
cd $InstallPath/VSCode_EPuck2.app/Contents/Resources/app/bin
echo
echo "Installing VSCode marus25.cortex-debug extension"
./code --install-extension marus25.cortex-debug --force
echo
echo "Installing VSCode ms-vscode.cpptools extension"
./code --install-extension ms-vscode.cpptools --force


#####################################################
##                  Workplace                      ##
#####################################################
ans=n
while [ $ans != y ]; do
    echo
    read -p "Workplace by default is ~/Documents/EPuck2" Workplace
    Workplace=${Workplace:-~/Documents/Workplace}
    echo
    echo "Are you sure you want your workplace to be at $Workplace ?"
    read -p "Enter y for Yes or n for No: " ans
done
mkdir -p $Workplace
cd $Workplace
echo 
echo "Cloning the libraries into the workplace"
git clone https://github.com/epfl-mobots/Lib_VSCode_e-puck2.git


#####################################################
##               VSCode Settings                   ##
#####################################################
echo
echo "Configuring vscode..."
cd $InstallPath/code-portable-data/user-data/User/
InstallPathD=${InstallPath//\//\/\/} #InstallPathDouble: replace / by //

echo "{" >> settings.json
#Path used by intellissense to locate lib source files
echo "	\"gcc_arm_path\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major\"," >> settings.json
#Compiler path
echo "	\"gcc_arm_path_compiler\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin//arm-none-eabi-gcc\"," >> settings.json
#Make path
echo "	\"make_path\": \"make\"," >> settings.json
#Path used for debuging (.svd), dfu
echo "	\"epuck2_utils\": \"$InstallPathD//EPuck2Tools//Utils\"," >> settings.json
echo "	\"workplace\": \"$Workplace\"," >> settings.json
echo "	\"terminal.integrated.env.osx\": {" >> settings.json
echo "	    \"PATH\": \"\${env:HOME}:$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin:\${env:PATH}\"" >> settings.json
echo "  }" >> settings.json
echo "}" >> settings.json

#####################################################
##               VSCode DFU Task                   ##
#####################################################
echo
echo "Adding dfu task to user level"
cp $origin_path/tasks.json tasks.json

echo
echo "*******************************************************"
echo "** Visual Studio Code EPuck2 successfully installed! **"
echo "*******************************************************"
echo

quitFunc