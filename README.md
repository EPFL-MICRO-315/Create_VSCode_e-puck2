# Introduction
This repository containing the installer for Visual Studio Code EPuck2 is to be downloaded or cloned on your computer.
MacOS, Windows and Linux are or will be in the very near future supported.  

## Fully tested Operating System
- MacOS Monterey (v12.5), should work on any MacOS not older than Catalina, could work on older version with some very minor tweaks

## Not tested Operating System / Installation script is not finished
### Tested on
- Windows
- Linux

# Installation method (only MacOS supported right now)
- download/clone the repository anywhere you want (e.g: ~/Download)
- open a terminal under Create_VSCode_e-puck2/MacOS
- execute chmod 700 install.sh
- execute ./install.sh 
- follow the installation steps (caution, be very patient for the installation, it's normal if it seems "stucked" for a few minutes) 

# TODO
- enhances the script "look" to be more user friendly 
   - differentiates (color and/or polices) the requests to the user from the command's log
   - manage case for answer like 'y' or 'Y'
- support as eclipse-epuck2 does the configuration of ChibiOS projects (board.chcfg file and dependencies) through some kind of .xml file
- modify installers in order to avoid to install anything already installed
- documents how to configure correctly the "Get Started" configuration at the first VSCode_EPuck2 launch
- uses make with the right threads number (-jx) where x is determined on the fly
  - use command "sysctl -n hw.logicalcpu" for MacOs 
