@echo off
set program=Visual Studio Code EPuck 2.lnk
set programVS=VSCode
set programGCC=gcc-arm-none-eabi-7-2017-q4-major
set programTools=Tools
set origin_path=%cd%
set InstallPath=%AppData%\VSCode_e-puck2

echo *****************************************************
echo ** Welcome to Visual Studio Code EPuck 2 installer **
echo *****************************************************
echo.
echo "see https://github.com/epfl-mobots/Create_VSCode_e-puck2"
echo "Released in 2022"
echo.

echo Proceed with the installation ?
set /p ans0="Enter y for Yes or any word for No: "
if /I %ans0%==n goto quitRoutine

:installationPath
echo.
echo Make sure there are now space in your installation path!
set /p "InstallPath=Enter path or just ENTER for default [%InstallPath%] : "

echo.
echo Are you sure you want it to be installed at %InstallPath% ?
set /p ans1="Enter y for Yes or any word for No: "
if /I %ans1% neq y goto installationPath

::Download softwares
echo.
echo Download VSCode
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive" --output vscode.zip

echo.
echo Download gcc-arm-none-eabi
curl -OL "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip"

if exist "%InstallPath%/VSCode" (
    echo %InstallPath/VSCode% is already existing, do you want to overwrite it ?
    set /p ans2="Enter y for Yes or any word for No: "
)
if /I %ans2%==n goto installGCC
tools\gnutools\7za.exe x vscode.zip -aoa -o%programVS%
rm vscode.zip
move %programVS% %InstallPath%\

:installGCC
if exist "%InstallPath%" (
    echo %InstallPath% is already existing, do you want to overwrite %InstallPath% ?
    set /p ans3="Enter y for Yes or n for No: "
)
if /I %ans3%==n goto tools
tools\gnutools\7za.exe x gcc-arm-none-eabi-7-2017-q4-major-win32.zip -aoa -o%programGCC%
rm gcc-arm-none-eabi-7-2017-q4-major-win32.zip
move %programGCC% %InstallPath%/

:tools
echo.
echo Copying Tools folder
xcopy Tools %InstallPath%/%programTools%

echo.
echo Set VSCode to run in portable mode
mkdir %InstallPath%/%programVS%/data

cd "%InstallPath%"
echo.
echo Installing VSCode marus25.cortex-debug extension
start cmd /C "%InstallPath%\%programVS%\bin\code.cmd --install-extension marus25.cortex-debug --force && pause"
echo Installing VSCode ms-vscode.cpptools extension
start cmd /C "%InstallPath%\%programVS%\bin\code.cmd --install-extension ms-vscode.cpptools --force && pause"

::Workplace
:workplace
echo.
echo Select the workplace where you will be working on
echo Make sure there are no spaces in your workingplace!
set /p "Workplace=Enter path or just ENTER for default [~/Documents/EPuck2] : "

echo.
echo "Are you sure you want your workplace to be at %Workplace% ?"
set /p ans4="Enter y for Yes or any word for No: "
if /I %ans4% neq y goto workingplace
mkdir %Workplace%
cd %Workplace%

echo. 
echo Cloning the libraries into the workplace
git clone https://github.com/epfl-mobots/epuck-2-libs.git


::Important VSCode settings definitions
echo.
echo Configuring vscode...
cd "%InstallPath%\%programVS%\data\user-data\User\"
set SettingsPath=%InstallPath:\=//%
echo { >> settings.json
echo	"explorer.confirmDelete": false, >> settings.json
echo	"gcc_arm_path": "%SettingsPath%//%programGCC%", >> settings.json
echo	"epuck_tools": "%SettingsPath%//%programTools%", >> settings.json
echo 	"workplace": "$Workplace" >> settings.json
echo } >> settings.json

echo.
echo Adding dfu task to user level
move $origin_path/task.json task.json

::Shortcuts creation
echo.
echo Creating shortcut...
cd "%InstallPath%"
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%InstallPath%\%program%" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%InstallPath%\%programVS%\Code.exe" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut creation
    goto quitRoutine
)
del %SCRIPT%
::see https://superuser.com/questions/455364/how-to-create-a-shortcut-using-a-batch-script for more info

echo.
echo Create shortcut under Desktop ? [y/n]
set /p ans="Enter y for Yes or n for No: "
if /I %ans% EQU y copy "%InstallPath%\%program%" "%USERPROFILE%\Desktop\%program%"
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut copying to Desktop
    goto quitRoutine
)

echo.
echo Create shortcut under Start Menu ? [y/n]
set /p ans="Enter y for Yes or n for No: "
if /I %ans% EQU y copy "%InstallPath%\%program%" "%AppData%\Microsoft\Windows\Start Menu\Programs\%program%"
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut copying to Start Menu
    goto quitRoutine
)
del "%program%"

echo.
echo *******************************************************
echo ** Visual Studio Code EPuck2 successfully installed! **
echo *******************************************************
echo.

:quitRoutine
    pause
    cd %origin_path%
    exit /b