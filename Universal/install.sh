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
