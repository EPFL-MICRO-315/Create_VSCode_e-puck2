#!/bin/bash

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

flush() {
    while read -n 1 -t 0
    do :
    done
}

yYn_ask() {
    tmp=0
    while [ $tmp != 1 ]; do
        flush
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

continueFunc() {
    flush
    echo -n -e $BPurple "Press any key to continue ..."
    read
    echo
}

quitFunc() {
    cd $InstallerPath
    flush
    echo -n -e $BRed "Press any key to quit ..."
    echo -e -n $Color_Off
    read
    exit
}

programVSFunc() {
    if test -f "$InstallerPath/vscode.tar.gz"; then
        echo
        echo -e $Cyan "$InstallerPath/vscode.tar.gz already downloaded"
        echo -e -n $Color_Off
    else
        echo
        echo -e $BPurple "Downloading VSCode"
        echo -e -n $Color_Off
        echo curl -L "https://update.code.visualstudio.com/latest/linux-x64/stable" --output $InstallerPath/vscode.tar.gz
        curl -L "https://update.code.visualstudio.com/latest/linux-x64/stable" --output $InstallerPath/vscode.tar.gz
    fi
    
    echo
    echo -e $Cyan "Extracting $InstallerPath/vscode.tar.gz"
    echo -e -n $Color_Off
    tar -xf $InstallerPath/vscode.tar.gz -C $InstallPath
    mv $InstallPath/VSCode-linux-x64 $InstallPath/VSCode_EPuck2

    echo check where vscode.tar.gz has been decompressed

    rm $InstallerPath/vscode.tar.gz

    echo
    echo -e $Cyan "Visual Studio Code installed"
    echo -e -n $Color_Off
}

EPuck2ToolsFuncGCC() {
    if test -f "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"; then
        echo
        echo -e $Cyan "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2 already downloaded"
        echo -e $BPurple "Do you want to re-download it ?"
        yYn_ask
        if [ $ans = y ]; then
            echo
            echo -e $Cyan "Re-downloading gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
            echo -e -n $Color_Off
            echo curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" --output "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
            curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" --output "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
        fi
    else
        echo
        echo -e $Cyan "Downloading gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
        echo -e -n $Color_Off
        echo curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" --output "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
        curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2" --output "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
    fi

    echo
    echo -e $Cyan "Installation of $InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2"
    echo -e -n $Color_Off
    mkdir -p $InstallPath/EPuck2Tools
    tar -xf $InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2 -C $InstallPath/EPuck2Tools/

    echo check where gcc-arm-none-eabi-7-2017-q4-major.tar.bz2 has been decompressed

    rm $InstallerPath/gcc-arm-none-eabi-7-2017-q4-major.tar.bz2
}

EPuck2ToolsFunc() {
    if [ -d "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major" ]; then 
        echo
        echo -e $BPurple "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major is already existing, do you want to overwrite it ?"
        yYn_ask
        echo -e -n $Color_Off
        if [ $ans = y ]; then
            rm -rf $InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major
            EPuck2ToolsFuncGCC
        fi
    else
        EPuck2ToolsFuncGCC
    fi

    cp -r $InstallerPath/Utils $InstallPath/EPuck2Tools/Utils
    echo
    echo -e $Cyan "Downloading epuck2 monitor"
    echo -e -n $Color_Off
    echo curl -L "https://projects.gctronic.com/epuck2/monitor_linux64bit.tar.gz" --output "$InstallerPath/monitor_linux64bit.tar.gz"
    curl -L "https://projects.gctronic.com/epuck2/monitor_linux64bit.tar.gz" --output "$InstallerPath/monitor_linux64bit.tar.gz"
    tar -xf $InstallerPath/monitor_linux64bit.tar.gz -C $InstallPath/EPuck2Tools/Utils
    mv $InstallPath/EPuck2Tools/Utils/build-qmake-Desktop_Qt_5_10_1_GCC_64bit-Release $InstallPath/EPuck2Tools/Utils/monitor_linux64bit

    if [ "$1" == "Debug" ]; then
        echo check where monitor_linux64bit.tar.gz or monitor_linux64bit has been decompressed
        continueFunc
    fi

    rm $InstallerPath/monitor_linux64bit.tar.gz

    echo
    echo -e $Cyan "EPuck2Tools installed"
    echo -e -n $Color_Off
}

#####################################################
##              BEGINNING OF SCRIPT               ##
#####################################################

InstallerPath=$(dirname "$0")
# If the script is runned from its folder, the folder name will be "." and all "cd" inside the script will be the reference "."
if [ "$InstallerPath" == "." ]; then
    InstallerPath=$(pwd)
fi

if [ "$1" == "Debug" ]; then
    echo -e -n $Color_Off
    echo 
    echo "  Beginninig of $0"
    echo
    echo "    InstallerPath = $InstallerPath"
    continueFunc
fi

#####################################################
## Welcome to Visual Studio Code EPuck 2 installer ##
#####################################################
clear
echo -e $BRed "*****************************************************"
echo -e $BRed "** Welcome to Visual Studio Code EPuck 2 installer **"
echo -e $BRed "*****************************************************"
echo
echo -e $Cyan "see https://github.com/EPFL-MICRO-315/Create_VSCode_e-puck2"
echo -e $Cyan "Released in 2022"
echo
echo -e $Red "Be extremely cautious when specifying installation paths, there are risk of damaging your installation "
echo -e $Red "For instance, do not directly install VSCode EPuck 2 under root /"
echo -e $BCyan "AND VERY IMPORTANT: Paths must NOT AT ALL contain any space or accented character!!"
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
echo -e $Cyan "Installing curl required to download vscode and compiler"
echo -e -n $Color_Off
sudo apt-get install curl
#sudo pacman -S curl #Uncomment if on system using pacman instead of apt-get

echo
echo -e $Cyan "Installing make"
echo -e -n $Color_Off
sudo apt-get install make
#sudo pacman -S make

echo
echo -e $Cyan "Installing dfu-util"
echo -e -n $Color_Off
sudo apt-get install dfu-util
#sudo pacman -S dfu-util

echo
echo -e $Cyan "Installating git"
echo -e -n $Color_Off
sudo apt-get install git
#sudo pacman -S git

echo
echo -e $BPurple "Installing git-credential-manager-core ?"
yYn_ask
if [ $ans = y ]; then
    echo -e -n $Color_Off
    echo curl -L "https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.785/gcm-linux_amd64.2.0.785.deb" --output "$InstallerPath/gcm-linux_amd64.2.0.785.deb"
    curl -L "https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.785/gcm-linux_amd64.2.0.785.deb" --output "$InstallerPath/gcm-linux_amd64.2.0.785.deb"
    sudo dpkg -i "$InstallerPath/gcm-linux_amd64.2.0.785.deb"
    git-credential-manager-core configure
    echo "[credential]" >> ~/.gitconfig
    echo "        credentialStore = secretservice" >> ~/.gitconfig
    rm $InstallerPath/gcm-linux_amd64.2.0.785.deb    
fi


#####################################################
##              Select Install Path                ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**              Select Install Path                **"
echo -e $BRed "*****************************************************"
ans=n
while [ $ans != y ]; do
    echo
    echo -e $BPurple "InstallPath by default is ~/Applications"
    echo -e $BPurple "If you want the IDE to be installed in the default InstallPath, press enter, otherwise just type your InstallPath"
    flush
    read InstallPath
    InstallPath=${InstallPath:-~/Applications}
    eval InstallPath=$InstallPath
    echo
    echo -e $BPurple "Are you sure you want it to be installed at $InstallPath ?"
    yYn_ask
done
echo
echo -e $Cyan "Creating the installation folder if not already existing"
echo -e -n $Color_Off
mkdir -p $InstallPath

#####################################################
##              Installation of VSCode             ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**              Installation of VSCode             **"
echo -e $BRed "*****************************************************"
if [ -d "$InstallPath/VSCode_EPuck2" ]; then
    echo
    echo -e $BPurple "$InstallPath/VSCode_EPuck2 is already existing, do you want to overwrite it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $InstallPath/VSCode_EPuck2
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
EPuck2ToolsFunc

#####################################################
##          VSCode Extensions Installation         ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**          VSCode Extensions Installation         **"
echo -e $BRed "*****************************************************"
if [ -d "$InstallPath/VSCode_EPuck2/data" ]; then
    echo
    echo -e $BPurple "$InstallPath/VSCode_EPuck2/data is already existing, do you want to clear it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $InstallPath/VSCode_EPuck2/data
        echo
        echo -e $BPurplen "Enabling VSCode portable mode"
        echo -e -n $Color_Off
        mkdir $InstallPath/VSCode_EPuck2/data
    fi
else
    echo
    echo -e $BPurple "Enabling VSCode portable mode"
    echo -e -n $Color_Off
    mkdir $InstallPath/VSCode_EPuck2/data
fi

cd $InstallPath/VSCode_EPuck2/bin
echo
echo -e $Cyan "Installing VSCode marus25.cortex-debug extension, version 1.4.4"
echo -e -n $Color_Off
./code --install-extension marus25.cortex-debug@1.4.4 --force
echo
echo -e $Cyan "Installing VSCode ms-vscode.cpptools extension"
echo -e -n $Color_Off
./code --install-extension ms-vscode.cpptools --force
echo
echo -e $Cyan "Installing VSCode forbeslindesay.forbeslindesay-taskrunner extension"
echo -e -n $Color_Off
./code --install-extension forbeslindesay.forbeslindesay-taskrunner --force
# echo
# echo -e $Cyan "Installing VSCode donjayamanne.githistory extension"
# echo -e -n $Color_Off
# ./code --install-extension donjayamanne.githistory --force
echo
echo -e $Cyan "Installing VSCode mhutchie.git-graph extension"
echo -e -n $Color_Off
./code --install-extension mhutchie.git-graph --force
echo
echo -e $Cyan "Installing VSCode tomoki1207.pdf extension"
echo -e -n $Color_Off
./code --install-extension tomoki1207.pdf --force

#####################################################
##               Workplace Setup                   ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**               Workplace Setup                   **"
echo -e $BRed "*****************************************************"
ans=n
while [ $ans != y ]; do
    echo
    echo -e $BPurple "Workplace by default is ~/Documents/Workplace_EPuck2"
    echo -e $BPurple "If you want the Workplace_EPuck2 to be in the default location, press enter, otherwise just type your Workplace path"
    flush
    read Workplace
    Workplace=${Workplace:-~/Documents/Workplace_EPuck2}
    eval Workplace=$Workplace
    echo
    echo -e $BPurple "Are you sure you want your workplace to be at $Workplace ?"
    yYn_ask
    echo -e -n $Color_Off
done
mkdir -p $Workplace
if [ -d "$Workplace/Lib" ]; then 
    echo
    echo -e $BPurple "$Workplace/Lib is already existing. Nothing else the Lib folder will be touched."
    echo -e $BPurple "  Do you want to clear the Lib folder and recreate it with the last version?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        rm -rf $Workplace/Lib
        echo 
        echo -e $Cyan "Cloning the libraries into the workplace"
        echo -e -n $Color_Off
        git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git $Workplace/Lib

    fi
fi
# cd $Workplace

FOLDER=$Workplace/Lib/e-puck2_main-processor/aseba/clients/studio/plugins/ThymioBlockly/blockly
if [ -f $FOLDER//package.json ]; then
    mv $FOLDER/package.json $FOLDER/package.json-renamed-to-avoid-been-as-task-4-vscode
fi

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

InstallPathD=${InstallPath//\//\/\/} #InstallPathDouble: replace / by //
FOLDER=$InstallPath/VSCode_EPuck2/data/user-data/User
FILE=$FOLDER/settings.json
echo "{" >> $FILE
#Otherwise the cortex debug extension will update which newer versions are not compatible with currently used arm-toolchain version
echo "  \"extensions.autoCheckUpdates\": false," >> $FILE
echo "  \"extensions.autoUpdate\": false," >> $FILE
#Path used by intellissense to locate lib source files
echo "	\"gcc_arm_path\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major\"," >> $FILE
#Compiler path
echo "	\"gcc_arm_path_compiler\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin//arm-none-eabi-gcc\"," >> $FILE
#Make path
echo "	\"make_path\": \"make\"," >> $FILE
#Path used for debuging (.svd), dfu
echo "	\"epuck2_utils\": \"$InstallPathD//EPuck2Tools//Utils\"," >> $FILE
echo "	\"InstallPath\": \"$InstallPath_D\"," >> $FILE
echo "	\"Version\": \"$InstallPath_D//VSCode_EPuck2//VERSION.md\"," >> $FILE
echo "	\"workplace\": \"$Workplace\"," >> $FILE
echo "	\"terminal.integrated.env.linux\": {" >> $FILE
echo "	    \"PATH\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin:\${env:PATH}\"}," >> $FILE
echo "	\"cortex-debug.armToolchainPath.linux\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin\"" >> $FILE
echo "}" >> $FILE

#####################################################
##               VSCode DFU Task                   ##
#####################################################
echo
echo -e $Cyan "Adding DFU and Library linking tasks to user level"
echo -e -n $Color_Off
cp $InstallerPath/tasks.json $FOLDER/tasks.json

#####################################################
##               Add User dialout                  ##
#####################################################
echo
echo -e $Cyan "Adding the user $USER to dialout group"
echo -e -n $Color_Off
sudo adduser $USER dialout

#####################################################
##               Copy RefTag info                  ##
#####################################################
echo
echo -e $Cyan "Copy RefTag info in order to know the exact installer commit"
echo -e -n $Color_Off
cp $InstallerPath/VERSION.md $InstallPath/VSCode_EPuck2

#####################################################
##               VSCode Shortcut                   ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**               VSCode Shortcut                   **"
echo -e $BRed "*****************************************************"
echo
echo -e $Cyan "Create shortcut under Desktop ?"
yYn_ask
echo -e -n $Color_Off
if [ $ans = y ]; then
    # Create the shortcut directly on the user desktop as the application is installed only for him
    FOLDER=~/Desktop
    FILE=$FOLDER/vscode_epuck2.desktop
    cd $InstallerPath
    echo "Exec=$InstallPath/VSCode_EPuck2/code" >> $FILE
    echo "Icon=$InstallPath/VSCode_EPuck2/resources/app/resources/linux/code.png" >> $FILE
    # According to https://www.how2shout.com/linux/allow-launching-linux-desktop-shortcut-files-using-command-terminal/
    # Mark the shortcut status trusted  
    gio set $FILE metadata::trusted true
    # Then allow execution
    chmod u+x $FILE
fi

echo
echo -e $BRed "*******************************************************"
echo -e $BRed "** Visual Studio Code EPuck2 successfully installed! **"
echo -e $BRed "*******************************************************"
echo

quitFunc
