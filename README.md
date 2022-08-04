# Operating Systems
## Windows
### Tested on
- Windows 10

## MacOS
### Tested on
- Monterey v12.5

## Linux
### Tested on
- Ubuntu one day

# GOAL
## Installation method
The user download the zip relative to the OS used.
zip structure:
	- install.sh / install.bat : installation script

vscode download link : https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive
arm-gcc download link : https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip
download soft :
- wget : not installed by default on any OS
- curl : seems to be installed on all windows >= 10 & macos & linux
- bitsadmin : installed on windows by default
bitsadmin /transfer mydownloadjob /download /priority FOREGROUND "http://example.com/File.zip" "C:\Downloads\File.zip"

## Installation method fallback
in case the first method doesn't work (e.g: very old OS)
zip structure;
	- install.sh / install.bat : installation script
	- vscode.zip
	- arm-gcc.zip

# TODO
- support live download
