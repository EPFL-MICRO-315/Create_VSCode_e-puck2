@echo off
cls
REM Call with "Debug" as parameter to have a control interactivity

set InstallerPath=%~dp0
set InstallerPath=%InstallerPath:~0,-1%

%InstallerPath%\gnutools\bash.exe %InstallerPath%\install_A.sh %InstallerPath% %1