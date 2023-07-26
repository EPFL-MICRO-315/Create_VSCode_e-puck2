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
    flush
    echo -e $BPurple "Workplace by default is ~/Documents/Workplace_VSCode_EPuck2"
    echo -e $BPurple "If you want the Workplace_EPuck2 to be in the default location, " $BGreen "press enter, otherwise just type your Workplace path"
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
else
    echo 
    echo -e $Cyan "Cloning the libraries into the workplace"
    echo -e -n $Color_Off
    git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git $Workplace/Lib
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
FOLDER=$InstallPath/code-portable-data/user-data/User
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
echo "	\"Version\": \"$InstallPath_D//VSCode_EPuck2.app//Content//VERSION.md\"," >> $FILE
echo "	\"workplace\": \"$Workplace\"," >> $FILE
echo "	\"terminal.integrated.env.osx\": {" >> $FILE
echo "	    \"PATH\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin:\${env:PATH}\"}," >> $FILE
echo "	\"cortex-debug.armToolchainPath.osx\": \"$InstallPathD//EPuck2Tools//gcc-arm-none-eabi-7-2017-q4-major//bin\"" >> $FILE
echo "}" >> $FILE

#####################################################
##               VSCode DFU Task                   ##
#####################################################

echo
echo -e $Cyan "Adding DFU & Library linking tasks to user level"
echo -e -n $Color_Off
cp $InstallerPath/tasks.json $FOLDER/tasks.json

#####################################################
##               Copy RefTag info                  ##
#####################################################
echo
echo -e $Cyan "Copy RefTag info in order to know the exact installer commit"
echo -e -n $Color_Off
cp $InstallerPath/VERSION.md $InstallPath//VSCode_EPuck2.app//Content

echo
echo -e $BRed "*******************************************************"
echo -e $BRed "** Visual Studio Code EPuck2 successfully installed! **"
echo -e $BRed "*******************************************************"
echo

quitFunc
