version = "V2.0 alpha"
f"""
Authors: Antoine Vincent Martin, Daniel Burnier
Date Created: August, 2022
Date Modified: January 30, 2024
Version: {version}
Python Version: 3.11.2
Dependencies:
License:
"""

import os
from os.path import expanduser
import sys
import time
import platform
import shutil
import logging
from utils import *

os_name = platform.system()
if os_name == "Windows":
    import subprocess

settings = {}

# Github Credential Manager uninstallation
def step1():
    os.chdir(settings["install_path"])
    logging.warning("Uninstalling git-credential-manager")
        
    if os_name == "Darwin":    
        os.system("brew uninstall --cask git-credential-manager")
        os.system("git config --global --unset credential.credentialStore keychain")
    elif os_name == "Windows":
        downloadTo(settings["gcm_url"], "git_setup.exe")
        logging.warning("Please uninstall git from the external dialog that opens right now")
        subprocess.run("git_setup.exe")
        if settings["clear_cache"]:
            os.remove("git_setup.exe")
    elif os_name == "Linux":
        os_cli("git-credential-manager unconfigure")
        os_cli("sudo dpkg -r gcm")
        
# Utils
def step2():
    os.chdir(settings["install_path"])
    
    util_dir = settings["install_path"] + "EPuck2_Utils"
    logging.warning(f"Deleting Utils: {util_dir}")
    rmdir(util_dir)
    

# VSCode
def step3():
    os.chdir(settings["install_path"])
    
    data_dir = settings["install_path"]
    bin_dir = settings["install_path"]
    if os_name == "Darwin":
        data_dir += "/code-portable-data/"
        bin_dir += "/EPuck2_VSCode.app/Contents/Resources/app/bin/"
    elif os_name == "Windows":
        data_dir += "/EPuck2_VSCode/data/"
        bin_dir += "/EPuck2_VSCode/bin/"
    elif os_name == "Linux":
        data_dir += "/EPuck2_VSCode/data/"
        bin_dir += "/EPuck2_VSCode/bin/"
    
    logging.warning(f"Deleting VSCode data_dir: {data_dir}")
    rmdir(data_dir)
    logging.warning(f"Deleting VSCode bin_dir: {bin_dir}")
    rmdir(bin_dir)
    
# Shortcut
def step4():
    logging.warning("Shortcut removal")
    
    if os_name == "Windows":
        logging.warning("Removing of the shortcut on Windows not yet implemented")
    elif os_name == "Linux":
        os.chdir(os.popen("echo $HOME/.local/share/applications").read().rstrip())
        filename = "vscode_epuck2.desktop"
        os.remove(filename)