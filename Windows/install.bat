gnutools\bash.exe install.sh

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