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
BCyan='\033[1;34m'        # Blue
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

yYn_ask() {
    tmp=0
    while [ $tmp != 1 ]; do
        echo -n -e "$BPurple Enter $BGreen y $BPurple or $BGreen Y $BPurple for Yes $BPurple and $BGreen any $BPurple for No: "
        read ans
        if [ ! -z "$ans" ]; then
            if [ $ans = y ] || [ $ans = Y ]; then
                ans=y
            fi
            tmp=1
        fi
    done
}

flush() {
    while read -n 1 -t 1
    do :
    done
}

quitFunc() {
    cd $origin_path
    echo -n -e $BRed "Press any key to quit ..."
    read
    exit
}

programVSFunc() {
    if test -f "vscode.zip"; then
        echo
        echo -e $Cyan "vscode.zip already downloaded"
        echo -e -n $Color_Off
    else
        echo
        echo -e $BPurple "Download VSCode"
        echo -e -n $Color_Off
        curl -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" --output vscode.zip
    fi
    
    echo
    echo -e $Cyan "Installation of vscode.zip"
    echo -e -n $Color_Off
    unzip -q vscode.zip
    rm vscode.zip
    mv "Visual Studio Code.app" $InstallPath/VSCode_EPuck2.app

    echo
    echo -e $Cyan "Visual Studio Code installed"
    echo -e -n $Color_Off
}

EPuck2ToolsFunc() {
    if test -f "gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"; then
        flush
        echo
        echo -e $Cyan "gcc-arm-none-eabi-7-2017-q4-major.tar.bz2 already downloaded"
        echo -e $BPurple "Do you want to re-download it ?"
        yYn_ask
        if [ $ans = y ]; then
            echo
            echo -e $Cyan "Re-downloading gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
            echo -e -n $Color_Off
            curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2" --output "gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
        fi
    else
        echo
        echo -e $Cyan "Download gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
        echo -e -n $Color_Off
        curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2" --output "gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
    fi

    echo
    echo -e $Cyan "Installation of gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
    echo -e -n $Color_Off
    tar -xf gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
    rm gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
    mkdir -p $InstallPath/EPuck2Tools
    mv gcc-arm-none-eabi-7-2017-q4-major $InstallPath/EPuck2Tools/
    cp -r Utils $InstallPath/EPuck2Tools/Utils
    
    echo
    echo -e $Cyan "Downloading epuck2 monitor"
    echo -e -n $Color_Off
    curl -L "https://projects.gctronic.com/epuck2/monitor_mac.zip" --output "monitor_mac.zip"
    unzip monitor_mac.zip
    mv EPuckMonitor.app $InstallPath/EPuck2Tools/Utils/EPuckMonitor.app

    echo
    echo -e $Cyan "EPuck2Tools installed"
    echo -e -n $Color_Off
}

#####################################################
## Welcome to Visual Studio Code EPuck 2 installer ##
#####################################################
clear
echo -e $BRed "*****************************************************"
echo -e $BRed "** Welcome to Visual Studio Code EPuck 2 installer **"
echo -e $BRed "*****************************************************"
echo
echo -e $Cyan "see https://github.com/epfl-mobots/Create_VSCode_e-puck2"
echo -e $Cyan "Released in 2022"
echo
echo -e $Red "Be extremely cautious when specifying installation paths, there are risk of damaging your installation "
echo -e $Red "For instance, do not directly install VSCode EPuck 2 under root /"
echo
echo -e $BPurple "Proceed with the installation ?"
yYn_ask
if [ $ans != y ]; then
    quitFunc
fi

#####################################################
##         Installation of utility softwares       ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**         Installation of utility softwares       **"
echo -e $BRed "*****************************************************"
echo
echo -e $Cyan "Installation of Homebrew required to install several utility programs"
echo -e -n $Color_Off
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo
echo -e $BPurple "Do you want to re-install the utility softwares if they are already installed ?"
yYn_ask
if [ $ans = y ]; then
    echo
    echo -e $Cyan "Installation of wget required to download vscode and compiler"
    echo -e -n $Color_Off
    brew reinstall wget

    echo
    echo -e $Cyan "Installation of dfu-util"
    echo -e -n $Color_Off
    brew reinstall dfu-util

    echo
    echo -e $Cyan "Installation of git and git-crendential-manager-core"
    echo -e -n $Color_Off
    brew reinstall git

    flush
    echo
    echo -e $BPurple "Do you want to re-install the git-credential-manager-core ?"
    yYn_ask
    if [ $ans = y ]; then
        echo -e $Cyan "Installation of git-crendential-manager-core"
        echo -e -n $Color_Off
        brew tap microsoft/git
        brew reinstall --cask git-credential-manager-core
    fi
else
    echo
    echo -e $Cyan "Installation of wget required to download vscode and compiler"
    echo -e -n $Color_Off
    brew install wget

    echo
    echo -e $Cyan "Installation of dfu-util"
    echo -e -n $Color_Off
    brew install dfu-util

    echo
    echo -e $Cyan "Installation of git"
    echo -e -n $Color_Off
    brew install git
    
    flush
    echo
    echo -e $BPurple "Do you want to install the git-credential-manager-core ?"
    yYn_ask
    if [ $ans = y ]; then
        echo -e $Cyan "Installation of git-crendential-manager-core"
        echo -e -n $Color_Off
        brew tap microsoft/git
        brew install --cask git-credential-manager-core
    fi
fi

#####################################################
##              Select Install Path                ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**              Select Install Path                **"
echo -e $BRed "*****************************************************"
flush
ans=n
while [ $ans != y ]; do
    echo
    echo -e $BPurple "InstallPath by default is ~/Applications"
    read InstallPath
    InstallPath=${InstallPath:-~/Applications}
    echo
    echo -e $BPurple "Are you sure you want it to be installed at $InstallPath ?"
    yYn_ask
done
echo
echo -e $Cyan "Creation of installation folder if not already existing"
echo -e -n $Color_Off
mkdir -p $InstallPath

#####################################################
##              Installation of VSCode             ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**              Installation of VSCode             **"
echo -e $BRed "*****************************************************"
if [ -d "$InstallPath/VSCode_EPuck2.app" ]; then
    flush
    echo
    echo -e $BPurple "$InstallPath/VSCode_EPuck2.app is already existing, do you want to overwrite it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $InstallPath/VSCode_EPuck2.app
        programVSFunc
    fi
else
    programVSFunc
fi

#####################################################
##              Install EPuck2Tools                ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**           Installation of EPuck2Tools           **"
echo -e $BRed "*****************************************************"
if [ -d "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major" ]; then 
    flush
    echo
    echo -e $BPurple "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major is already existing, do you want to overwrite it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major
        EPuck2ToolsFunc
    fi
else
    EPuck2ToolsFunc
fi

#####################################################
##          VSCode Extensions Installation         ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**          VSCode Extensions Installation         **"
echo -e $BRed "*****************************************************"
if [ -d "$InstallPath/code-portable-data" ]; then
    flush
    echo
    echo -e $BPurple "$InstallPath/code-portable-data is already existing, do you want to clear it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $InstallPath/code-portable-data
        echo
        echo -e $BPurplen "Enabling VSCode portable mode"
        echo -e -n $Color_Off
        mkdir $InstallPath/code-portable-data
    fi
else
    echo
    echo -e $BPurple "Enabling VSCode portable mode"
    echo -e -n $Color_Off
    mkdir $InstallPath/code-portable-data
fi

cd $InstallPath/VSCode_EPuck2.app/Contents/Resources/app/bin
echo
echo -e $Cyan "Installing VSCode marus25.cortex-debug extension, version 1.4.4"
echo -e -n $Color_Off
./code --install-extension marus25.cortex-debug@1.4.4 --force
echo
echo -e $Cyan "Installing VSCode ms-vscode.cpptools extension"
echo -e -n $Color_Off
./code --install-extension ms-vscode.cpptools --force
echo
echo -e $Cyan "Installing VSCode SanaAjani.taskrunnercode extension"
echo -e -n $Color_Off
./code --install-extension SanaAjani.taskrunnercode --force
echo
echo -e $Cyan "Installing VSCode donjayamanne.githistory extension"
echo -e -n $Color_Off
./code --install-extension donjayamanne.githistory --force

#####################################################
##               Workplace Setup                   ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**               Workplace Setup                   **"
echo -e $BRed "*****************************************************"
flush
ans=n
while [ $ans != y ]; do
    echo
    echo -e $BPurple "Workplace by default is ~/Documents/Workplace_VSCode_EPuck2"
    read Workplace
    Workplace=${Workplace:-~/Documents/Workplace_VSCode_EPuck2}
    echo
    echo -e $BPurple "Are you sure you want your workplace to be at $Workplace ?"
    yYn_ask
    echo -e -n $Color_Off
done
mkdir -p $Workplace
if [ -d "$Workplace/Lib" ]; then 
    flush
    echo
    echo -e $BPurple "$Workplace/Lib is already existing, do you want to clear it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $Workplace/Lib
    fi
fi
cd $Workplace
echo 
echo -e $Cyan "Cloning the libraries into the workplace"
echo -e -n $Color_Off
git clone https://github.com/epfl-mobots/Lib_VSCode_e-puck2.git Lib


#####################################################
##               VSCode Settings                   ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**               VSCode Settings                   **"
echo -e $BRed "*****************************************************"
echo
echo -e $Cyan "Configuring vscode..."
echo -e -n $Color_Off
cd $InstallPath/code-portable-data/user-data/User/
InstallPathD=${InstallPath//\//\/\/} #InstallPathDouble: replace / by //

echo "{" >> settings.json
#Otherwise the cortex debug extension will update which newer versions are not compatible with currently used arm-toolchain version
echo "  \"extensions.autoCheckUpdates\": false," >> settings.json
echo "  \"extensions.autoUpdate\": false," >> settings.json
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
echo -e $Cyan "Adding DFU & Librairy linking tasks to user level"
echo -e -n $Color_Off
cp $origin_path/tasks.json tasks.json

echo
echo -e $BRed "*******************************************************"
echo -e $BRed "** Visual Studio Code EPuck2 successfully installed! **"
echo -e $BRed "*******************************************************"
echo

quitFunc