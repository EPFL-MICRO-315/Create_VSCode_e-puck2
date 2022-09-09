#!/gnutools/bash
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
BICyan='\033[1;34m'        # Blue
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
        curl -L "https://update.code.visualstudio.com/latest/win32-x64-archive/stable" --output vscode.zip
    fi
    
    echo
    echo -e $Cyan "Installation of vscode.zip"
    echo -e -n $Color_Off
    /gnutools/7za.exe x vscode.zip -oVSCode_EPuck2
    
    /gnutools/rm vscode.zip
    /gnutools/mv "VSCode_EPuck2" $InstallPath/VSCode_EPuck2

    echo
    echo -e $Cyan "Visual Studio Code installed"
    echo -e -n $Color_Off
}

EPuck2ToolsFunc() {
    if test -f "gcc-arm-none-eabi-7-2017-q4-major-win32.zip"; then
        echo
        echo -e $Cyan "gcc-arm-none-eabi-7-2017-q4-major-win32.zip already downloaded"
        echo -e $BPurple "Do you want to re-download it ?"
        echo -n -e $BPurple "Enter y or Y for Yes and any for No: "
        read ans
        if [ $ans = y ] || [ $ans = Y ]; then
            echo
            echo -e $Cyan "Re-downloading gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
            echo -e -n $Color_Off
            curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip" --output "gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
        fi
    else
        echo
        echo -e $Cyan "Download gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
        echo -e -n $Color_Off
        curl -L "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip" --output "gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
    fi

    echo
    echo -e $Cyan "Installation of gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
    echo -e -n $Color_Off
    /gnutools/7za.exe x gcc-arm-none-eabi-7-2017-q4-major-win32.zip -ogcc-arm-none-eabi-7-2017-q4-major

    /gnutools/rm gcc-arm-none-eabi-7-2017-q4-major-win32.zip
    /gnutools/mkdir -p $InstallPath/EPuck2Tools
    /gnutools/mv gcc-arm-none-eabi-7-2017-q4-major $InstallPath/EPuck2Tools/
    /gnutools/cp -r Utils $InstallPath/EPuck2Tools/Utils
    /gnutools/cp -r gnutools $InstallPath/EPuck2Tools/gnutools

    echo
    echo -e $Cyan "EPuck2Tools installed"
    echo -e -n $Color_Off
}

#####################################################
## Welcome to Visual Studio Code EPuck 2 installer ##
#####################################################
echo -e $BRed "*****************************************************"
echo -e $BRed "** Welcome to Visual Studio Code EPuck 2 installer **"
echo -e $BRed "*****************************************************"
echo
echo -e $Cyan "see https://github.com/epfl-mobots/Create_VSCode_e-puck2"
echo -e $Cyan "Released in 2022"
echo
echo -e $Red "Be extremely cautious when specifying installation paths, there are risk of damaging your installation "
echo -e $Red "For instance, do not directly install VSCode EPuck 2 under root C:/"
echo
echo -e $BPurple "Proceed with the installation ?"
echo -n -e $BPurple "Enter y or Y for Yes and any for No: "
read ans
if [ $ans != y ] && [ $ans != Y ]; then
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


echo
echo -e $BPurple "Do you want to (re)install git ? (this installer have a very handy git credential manager)"
echo -n -e $BPurple "Enter y or Y for Yes and any for No: "
read ans
echo -e -n $Color_Off
if [ $ans = y ] || [ $ans = Y ]; then
    echo
    echo -e $Cyan "Downloading of git"
    echo -e -n $Color_Off
    curl -L "https://github.com/git-for-windows/git/releases/download/v2.37.3.windows.1/Git-2.37.3-64-bit.exe" --output "git_setup.exe"
    echo -e $Cyan "Please install git"
    git_setup.exe
    echo -e -n $Color_Off
    /gnutools/rm git_setup.exe
fi
echo
echo -e $Cyan "Reloading the PATH variables"
echo -e -n $Color_Off
./install_B.sh

quitFunc