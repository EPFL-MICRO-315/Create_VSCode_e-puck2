@echo off

::Shortcuts creation
set program=Visual Studio Code EPuck 2.lnk
set programVS=VSCode EPuck2
set origin_path=%cd%

echo.
echo Creating shortcut..
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%origin_path%\%program%" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%origin_path%\Code.exe" >> %SCRIPT%
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
if /I %ans% EQU y copy "%origin_path%\%program%" "%USERPROFILE%\Desktop\%program%"
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut copying to Desktop
    goto quitRoutine
)

echo.
echo Create shortcut under Start Menu ? [y/n]
set /p ans="Enter y for Yes or n for No: "
if /I %ans% EQU y copy "%origin_path%\%program%" "%AppData%\Microsoft\Windows\Start Menu\Programs\%program%"
if %errorlevel% NEQ 0 (
    echo fatal error %errorlevel% during shortcut copying to Start Menu
    goto quitRoutine
)
del "%program%"

pause
:quitRoutine
exit