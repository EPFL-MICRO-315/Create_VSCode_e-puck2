@echo off
set program=Visual Studio Code EPuck 2.lnk
set origin_path=%cd%
set InstallPath=%AppData%\vscode_epuck2

echo *****************************************************
echo ** Welcome to Visual Studio Code EPuck 2 installer **
echo *****************************************************
echo.
echo Released in 2022
echo.

echo Proceed with the installation ?
set /p ans0="Enter y for Yes or n for No: "
if /I %ans0%==n goto quitRoutine
echo Make sure there are now space in your installation path!
set /p "InstallPath=Enter path or just ENTER for default [%InstallPath%] : "

echo Are you sure you want it to be installed at %InstallPath% ?
set /p ans1="Enter y for Yes or n for No: "
if /I %ans1% neq y goto quitRoutine

set ans2=""
if exist "%InstallPath%" (
    echo %InstallPath% is already existing, do you want to overwrite %InstallPath% ?
    set /p ans2="Enter y for Yes or n for No: "
)
if /I %ans2%==n goto installExtensions

::/E for directory copying, /i to assume destination is a directory, /q quiet mode, /Y for yes for all
echo Copying vscode into %InstallPath%...
xcopy "vscode_epuck2" "%InstallPath%" /E /i /q /Y
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during copy
    goto quitRoutine
)

:installExtensions
cd "%InstallPath%"
echo Installing VSCode marus25.cortex-debug extension
start cmd /C "%InstallPath%\VSCode-win32-x64-1.69.2\bin\code.cmd --install-extension marus25.cortex-debug --force && pause"
echo Installing VSCode ms-vscode.cpptools extension
start cmd /C "%InstallPath%\VSCode-win32-x64-1.69.2\bin\code.cmd --install-extension ms-vscode.cpptools --force && pause"

::set few important definitions
cd "%InstallPath%\VSCode-win32-x64-1.69.2\data\user-data\User\"
set InstallPath2=%InstallPath:\=//%
echo { >> settings.json
echo	"explorer.confirmDelete": false, >> settings.json
echo	"gcc_arm_path": "%InstallPath2%//gcc-arm-none-eabi-7-2017-q4-major-win32", >> settings.json
echo	"epuck_tools": "%InstallPath2%//tools" >> settings.json
echo } >> settings.json

echo Creating shortcut...
cd "%InstallPath%"
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%InstallPath%\%program%" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%InstallPath%\VSCode-win32-x64-1.69.2\Code.exe" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut creation
    goto quitRoutine
)
del %SCRIPT%
::see https://superuser.com/questions/455364/how-to-create-a-shortcut-using-a-batch-script for more info

echo Create shortcut under Desktop ? [y/n]
set /p ans="Enter y for Yes or n for No: "
if /I %ans% EQU y copy "%InstallPath%\%program%" "%USERPROFILE%\Desktop\%program%"
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut copying to Desktop
    goto quitRoutine
)

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
