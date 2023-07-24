# Introduction
- the current installer situation is the following
    - installers on Windows, Linux and MacOS are written in bash
    - Linux installer is kind of deprecated
    - all are written in bash but they all have their own specifities, thus there is one script per OS
    - it is therefore hard to maintain
    - bash is hard to read and the way the scripts are written is not modular
    - have to re-run the entire script even if only one part of the IDE is missing
    - no log at all

# Requirements for the next installer script
- one script to rule them all
    - => easier to maintain

# Rejected proposition
- docker
    - it requires installing WSL2 to have a gui
    - WSL2 only available on machine with at least 7th gen processors

# Universal Installer proposition
- scripting language: python
    - it is cross-platform, there are packages for pretty much every case
    - packages to be used:
        - tarfile for compressed file
        - requests equivalent to wget or curl
        - ...
    - the host machine require python to be installed first!

## Installation process description, step by step
1. User install python, we don't provide script or anything, we give him a link, he downloads it and then install python
2. User download and run the install script, 2 choices:
    - with `curl`, like homebrew or like pip in the pas
    - manually download and run
3. Installation Script steps after launching it:
    - script prompt the user:
        - uninstall
        - install default:
        - install custom:
            - user can choose:
                - install directory
                - component of the installation to skip
    - if install selected:
        1. install pyenv or similar with all the required packages
        2. continue with the installation
            - git
            - vscode
            - vscode extensions
            - vscode configuration
            - arm gcc
            - other tools (epuck-monitor, ...)


## GUI look and feel
### Welcome page
***********************************
*|-------------------------------|*
*| Install VSCode EPuck2 Tools   |*
*|-------------------------------|*
*| Uninstall VSCode EPuck2 Tools |*
*|-------------------------------|*
*|           Settings            |*
*|-------------------------------|*
***********************************

### Install / Uninstall page
*****************************
*|-------------------------|*
*| > pacman install gcc    |*
*|   [//////----------]    |*
*|                         |*
*|                         |*
*|                         |*
*|-------------------------|*
*****************************

### Settings
**********************************
*|------------------------------|*
*| Install folder         | C:/ |*
*| Workspace folder       | C:/ |*
*| (re)install git        | [ ] |*
*| (re)install arm        | [ ] |*
*| (re)install vscode     | [ ] |*
*| (re)install extensions | [ ] |*
*| (re)configure vscode   | [ ] |*
*| (re)install library    | [ ] |*
*| create shortcut        | [ ] |*
*|------------------------------|*
**********************************


