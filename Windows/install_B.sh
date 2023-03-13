#!/gnutools/bash

InstallerPath=$1
InstallerPath=${InstallerPath//\\///}

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
    while read -n 1 -t1
    do :
    done
}

quitFunc() {
    cd $InstallerPath
    echo -n -e $BRed "Press any key to quit ..."
    read
    exit
}

programVSFunc() {
    if test -f "$InstallerPath/vscode.zip"; then
        echo
        echo -e $Cyan "vscode.zip already downloaded"
        echo -e -n $Color_Off
    else
        echo
        echo -e $BPurple "Download VSCode"
        echo -e -n $Color_Off
        curl -Lk "https://update.code.visualstudio.com/latest/win32-x64-archive/stable" --output $InstallerPath/vscode.zip
    fi
    
    echo
    echo -e $Cyan "Installation of vscode.zip"
    echo -e -n $Color_Off
    /gnutools/7za.exe x $InstallerPath/vscode.zip -o$InstallPath/VSCode_EPuck2
    
    /gnutools/rm $InstallerPath/vscode.zip

    echo
    echo -e $Cyan "Visual Studio Code installed"
    echo -e -n $Color_Off
}

EPuck2ToolsFuncGCC() {
    if test -f "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major-win32.zip"; then
        echo
        echo -e $Cyan "gcc-arm-none-eabi-7-2017-q4-major-win32.zip already downloaded"
        echo -e $BPurple "Do you want to re-download it ?"
        flush
        yYn_ask
        if [ $ans = y ]; then
            echo
            echo -e $Cyan "Re-downloading gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
            echo -e -n $Color_Off
            curl -Lk "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip" --output "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
        fi
    else
        echo
        echo -e $Cyan "Download gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
        echo -e -n $Color_Off
        curl -Lk "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip" --output "$InstallerPath/gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
    fi
        
    echo
    echo -e $Cyan "Installation of gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
    echo -e -n $Color_Off
    /gnutools/mkdir -p $InstallPath/EPuck2Tools
    /gnutools/7za.exe x $InstallerPath/gcc-arm-none-eabi-7-2017-q4-major-win32.zip -o$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major
    /gnutools/rm $InstallerPath/gcc-arm-none-eabi-7-2017-q4-major-win32.zip
}

EPuck2ToolsFunc() {
    if [ -d "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major" ]; then 
        echo
        echo -e $BPurple "$InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major is already existing, do you want to overwrite it ?"
        flush
        yYn_ask
        echo -e -n $Color_Off
        if [ $ans = y ]; then
            /gnutools/rm -rf $InstallPath/EPuck2Tools/gcc-arm-none-eabi-7-2017-q4-major
            EPuck2ToolsFuncGCC
        fi
    else
        EPuck2ToolsFuncGCC
    fi
    
    /gnutools/cp -r $InstallerPath/Utils $InstallPath/EPuck2Tools/Utils
    /gnutools/cp -r $InstallerPath/gnutools $InstallPath/EPuck2Tools/gnutools

    echo
    echo -e $Cyan "Downloading epuck2 monitor"
    echo -e -n $Color_Off
    curl -Lk "https://projects.gctronic.com/epuck2/monitor_win.zip" --output "$InstallerPath/monitor_win.zip"
    /gnutools/7za.exe x $InstallerPath/monitor_win.zip -o$InstallPath/EPuck2Tools/Utils/monitor_win

    echo
    echo -e $Cyan "EPuck2Tools installed"
    echo -e -n $Color_Off
}

#####################################################
##              Select Install Path                ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**              Select Install Path                **"
echo -e $BRed "*****************************************************"
flush
ans=n
APPDATA=${APPDATA//\\///}
while [ $ans != y ] && [ $ans != Y ]; do
    echo
    echo -e $BPurple "InstallPath by default is $APPDATA"
    echo -e $BPurple "If you want the IDE to be installed in the default InstallPath, press enter, otherwise just type your InstallPath"
    flush
    read -r InstallPath
    InstallPath=${InstallPath:-$APPDATA}
    InstallPath=${InstallPath//\\///}
    echo
    echo -e $BPurple "Are you sure you want it to be installed at $InstallPath ?"
    yYn_ask
done
echo
echo -e $Cyan "Creation of installation folder if not already existing"
echo -e -n $Color_Off
/gnutools/mkdir -p $InstallPath

#####################################################
##              Installation of VSCode             ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**              Installation of VSCode             **"
echo -e $BRed "*****************************************************"
if [ -d "$InstallPath/VSCode_EPuck2" ]; then
    flush
    echo
    echo -e $BPurple "$InstallPath/VSCode_EPuck2 is already existing, do you want to overwrite it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        /gnutools/rm -rf $InstallPath/VSCode_EPuck2
        programVSFunc
    fi
else
    programVSFunc
fi
/gnutools/cp $InstallerPath/shortcut.bat $InstallPath/VSCode_EPuck2/shortcut.bat

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
    flush
    echo
    echo -e $BPurple "$InstallPath/VSCode_EPuck2/data is already existing, do you want to clear it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        /gnutools/rm -rf $InstallPath/VSCode_EPuck2/data
        echo
        echo -e $BPurplen "Enabling VSCode portable mode"
        echo -e -n $Color_Off
        /gnutools/mkdir $InstallPath/VSCode_EPuck2/data
    fi
else
    echo
    echo -e $BPurple "Enabling VSCode portable mode"
    echo -e -n $Color_Off
    /gnutools/mkdir $InstallPath/VSCode_EPuck2/data
fi

cd $InstallPath/VSCode_EPuck2/
echo
echo -e $Cyan "Installing VSCode marus25.cortex-debug extension, version 1.4.4"
echo -e -n $Color_Off
cmd.exe /c "$InstallPath/VSCode_EPuck2/bin/code.cmd --install-extension marus25.cortex-debug@1.4.4 --force"
echo
echo -e $Cyan "Installing VSCode ms-vscode.cpptools extension"
echo -e -n $Color_Off
cmd.exe /c "$InstallPath/VSCode_EPuck2/bin/code.cmd --install-extension ms-vscode.cpptools --force"
echo
echo -e $Cyan "Installing VSCode forbeslindesay.forbeslindesay-taskrunner extension"
echo -e -n $Color_Off
cmd.exe /c "$InstallPath/VSCode_EPuck2/bin/code.cmd --install-extension forbeslindesay.forbeslindesay-taskrunner --force"
# echo
# echo -e $Cyan "Installing VSCode donjayamanne.githistory extension"
# echo -e -n $Color_Off
# cmd.exe /c "$InstallPath/VSCode_EPuck2/bin/code.cmd --install-extension donjayamanne.githistory --force"
echo
echo -e $Cyan "Installing VSCode mhutchie.git-graph extension"
echo -e -n $Color_Off
cmd.exe /c "$InstallPath/VSCode_EPuck2/bin/code.cmd --install-extension mhutchie.git-graph --force"
echo
echo -e $Cyan "Installing VSCode tomoki1207.pdf extension"
echo -e -n $Color_Off
cmd.exe /c "$InstallPath/VSCode_EPuck2/bin/code.cmd --install-extension tomoki1207.pdf --force"

#####################################################
##               Workplace Setup                   ##
#####################################################
echo
echo -e $BRed "*****************************************************"
echo -e $BRed "**               Workplace Setup                   **"
echo -e $BRed "*****************************************************"
flush
ans=n
USERPROFILE=${USERPROFILE//\\///}
while [ $ans != y ] && [ $ans != Y ]; do
    echo
    echo -e $BPurple "Workplace by default is $USERPROFILE\Documents\Workplace_EPuck2"
    echo -e $BPurple "If you want the Workplace_EPuck2 to be in the default location, press enter, otherwise just type your Workplace path"
    flush
    read -r Workplace
    Workplace=${Workplace:-$USERPROFILE\\Documents\\Workplace_EPuck2}
    Workplace=${Workplace//\\///}
    echo
    echo -e $BPurple "Are you sure you want your workplace to be at $Workplace ?"
    yYn_ask
    echo -e -n $Color_Off
done
/gnutools/mkdir -p $Workplace
if [ -d "$Workplace/Lib" ]; then 
    flush
    echo
    echo -e $BPurple "$Workplace/Lib is already existing, do you want to clear it ?"
    yYn_ask
    echo -e -n $Color_Off
    if [ $ans = y ]; then
        /gnutools/rm -rf $Workplace/Lib
    fi
fi
echo
echo -e $Cyan "Cloning the libraries into the workplace"
echo -e -n $Color_Off
git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git $Workplace/Lib

FOLDER=$Workplace/Lib/e-puck2_main-processor/aseba/clients/studio/plugins/ThymioBlockly/blockly
mv $FOLDER/package.json $FOLDER/package.json-renamed-to-avoid-been-as-task-4-vscode

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
InstallPathD=${InstallPath//\\///} #InstallPathDouble: replace \ by //
WorkplaceD=${Workplace//\\///}
WorkplaceAS=${WorkplaceD//\//\\}
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
echo "	\"make_path\": \"$InstallPathD//EPuck2Tools//gnutools//make\"," >> $FILE
#Path used for debuging (.svd), dfu
echo "	\"epuck2_utils\": \"$InstallPathD//EPuck2Tools//Utils\"," >> $FILE
echo "	\"workplace\": \"$WorkplaceD\"," >> $FILE
echo "	\"workplaceAS\": \"$WorkplaceAS\"," >> $FILE
echo "	\"terminal.integrated.env.windows\": {" >> $FILE
echo "	    \"PATH\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin;$InstallPathD//EPuck2Tools//gnutools;${env:PATH}\"}," >> $FILE
echo "	\"terminal.integrated.defaultProfile.windows\": \"Git Bash\"," >> $FILE
echo "	\"cortex-debug.armToolchainPath.windows\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin\"" >> $FILE
echo "}" >> $FILE

#####################################################
##               VSCode DFU Task                   ##
#####################################################
echo
echo -e $Cyan "Adding DFU and Library linking tasks to user level"
echo -e -n $Color_Off
/gnutools/cp $InstallerPath/tasks.json $FOLDER/tasks.json

#####################################################
##               Copy RefTag info                  ##
#####################################################
echo
echo -e $Cyan "Copy RefTag info in order to know the exact installer commit"
echo -e -n $Color_Off
/gnutools/cp $InstallerPath/VERSION.md $InstallPath/VSCode_EPuck2

#####################################################
##                   Shortcut                      ##
#####################################################
cd $InstallPath/VSCode_EPuck2
cmd.exe /c "start $InstallerPath/shortcut.bat"

echo
echo -e $BRed "*******************************************************"
echo -e $BRed "** Visual Studio Code EPuck2 successfully installed! **"
echo -e $BRed "*******************************************************"
echo