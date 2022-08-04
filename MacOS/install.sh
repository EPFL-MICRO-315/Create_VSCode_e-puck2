#!/bin/bash
programVS=VSCode_EPuck2.app
data="code-portable-data"
programGCC=gcc-arm-none-eabi-7-2017-q4-major
programTools=Tools

origin_path=$PWD
debug="true"

quitFunc() {
    cd $origin_path
    read -p "Press any key to quit ..."
    exit
}

copyFunc() {
    #if [ $debug = "true"]; then
    cp -r $programVS $InstallPath/$programVS
    #else
        #mv $programVS $InstallPath/$programVS
    #fi
}

portableFunc() {
    mkdir $InstallPath/$data #enable portable mode
}

echo "*****************************************************"
echo "** Welcome to Visual Studio Code EPuck 2 installer **"
echo "*****************************************************"
echo
echo "Released in 2022"
echo

echo "Proceed with the installation ?"
read -p "Enter y for Yes or n for No: " ans
if [ $ans != y ]; then
    quitFunc
fi

echo "Make sure there are no spaces in your installation path!"
read -p "InstallPath by default is ~/Applications" InstallPath
InstallPath=${InstallPath:-~/Applications/}
echo $InstallPath

echo "Are you sure you want it to be installed at $InstallPath ?"
read -p "Enter y for Yes or n for No: " ans
if [ $ans != y ]; then
    quitFunc
fi

if [ -d "$InstallPath/$programVS" ]; then 
    echo "$InstallPath/$programVS is already existing, do you want to overwrite it ?"
    read -p "Enter y for Yes or n for No: " ans
    if [ $ans = y ]; then
        copyFunc
    fi
else
    copyFunc
fi
portableFunc


#Install extensions
cd $InstallPath/$programVS/Contents/Resources/app/bin
echo "Installing VSCode marus25.cortex-debug extension"
./code --install-extension marus25.cortex-debug --force
echo "Installing VSCode ms-vscode.cpptools extension"
./code --install-extension ms-vscode.cpptools --force

#Working
echo "Select the workplace where you will be working on"
echo "Make sure there are no spaces in your workingplace!"
read -p "Workplace by default is ~/Documents/EPuck2" Workplace
Workplace=${Workplace:-~/Documents/Workplace}

echo "Are you sure you want your workplace to be at $Workplace ?"
read -p "Enter y for Yes or n for No: " ans
if [ $ans != y ]; then
    quitFunc
fi
mkdir $Workplace
cd $Workplace
#if [ $debug = "false"]; then
#git clone https://github.com/epfl-mobots/epuck-2-libs.git
#fi

#Few important definitions
cd $InstallPath/$data/user-data/User/
SettingsPath=${InstallPath/$data//\//\/\/}
echo "{" >> settings.json
echo "	\"explorer.confirmDelete\": false," >> settings.json
echo "	\"gcc_arm_path\": \"$SettingsPath/$programVS//Contents//gcc-arm-none-eabi-7-2017-q4-major\"," >> settings.json
echo "	\"epuck_tools\": \"$SettingsPath/$programVS//Contents//Tools\"," >> settings.json
echo "	\"workplace\": \"$Workplace\"" >> settings.json
echo "}" >> settings.json

echo
echo "*******************************************************"
echo "** Visual Studio Code EPuck2 successfully installed! **"
echo "*******************************************************"
echo

quitFunc

sudo adduser $USER dialout #to access serial ports
