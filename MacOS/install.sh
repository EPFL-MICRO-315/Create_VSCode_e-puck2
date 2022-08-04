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

programVSFunc() {
    echo
    echo Extracting vscode.zip
    unzip -q vscode.zip
    mv "Visual Studio Code.app" $InstallPath/$programVS
}

dataFunc() {
    echo
    echo Enabling VSCode portable mode
    mkdir $InstallPath/$data #enable portable mode
    mv Tools $InstallPath/$programVS/Contents/
}

programGCCFunc() {
    echo
    echo Extracting gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2
    tar -xf gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2
    mv gcc-arm-none-eabi-7-2017-q4-major-mac $InstallPath/$programVS/Contents/$programGCC
}

echo "*****************************************************"
echo "** Welcome to Visual Studio Code EPuck 2 installer **"
echo "*****************************************************"
echo
echo "see https://github.com/epfl-mobots/Create_VSCode_e-puck2"
echo "Released in 2022"
echo

echo "Proceed with the installation ?"
read -p "Enter y for Yes, any word for No: " ans
if [ $ans != y ]; then
    quitFunc
fi

echo
echo "Installation of Homebrew by several utility programs"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo
echo "Installation of wget required to download vscode and compiler"
brew install wget

echo
echo "Make sure there are no spaces in your installation path!"
read -p "InstallPath by default is ~/Applications" InstallPath
InstallPath=${InstallPath:-~/Applications/}

echo
echo "Are you sure you want it to be installed at $InstallPath ?"
read -p "Enter y for Yes, any word for No: " ans
while [ $ans != y ]; do
    echo
    read -p "InstallPath by default is ~/Applications" InstallPath
    InstallPath=${InstallPath:-~/Applications/}
done

echo
echo "Download VSCode"
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" --output vscode.zip

echo
echo "Download gcc-arm-none-eabi"
curl -OL "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2"

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

programGCCFunc

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
#git clone https://github.com/epfl-mobots/epuck-2-libs.git

#Important VSCode settings definitions
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