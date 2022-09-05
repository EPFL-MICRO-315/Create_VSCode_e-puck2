#!/bin/bash
origin_path=$PWD

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

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

echo -e $Yellow "*****************************************************"
echo -e $Yellow "** Welcome to Visual Studio Code EPuck 2 installer **"
echo -e $Yellow "*****************************************************"
echo
echo -e $Blue "see https://github.com/epfl-mobots/Create_VSCode_e-puck2"
echo -e $Yellow "Released in 2022"
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
./code --install-extension marus25.cortex-debug@1.4.4 --force
echo
echo "Installing VSCode ms-vscode.cpptools extension"
./code --install-extension ms-vscode.cpptools --force
echo
echo "Installing VSCode SanaAjani.taskrunnercode extension"
./code --install-extension SanaAjani.taskrunnercode --force

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
echo "	    \"PATH\": \"\${env:HOME}:/usr/local/bin:$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin:\${env:PATH}\"}," >> settings.json
echo "	\"cortex-debug.armToolchainPath.osx\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin\"" >> settings.json
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