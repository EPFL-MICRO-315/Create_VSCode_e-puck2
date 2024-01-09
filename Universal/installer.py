version = "V2.0 alpha"
f"""
Description: This script performs data preprocessing tasks for a machine learning project.
Authors: Antoine Vincent Martin, Daniel Burnier
Date Created: August, 2022
Date Modified: July 31, 2023
Version: {version}
Python Version: 3.10.12
Dependencies: kivy, termcolor
License: WTFPL
"""

import os
import sys
import time
import platform
import shutil
from termcolor import colored
import colorama
from utils import *
from kivy.logger import Logger

colorama.init()
origin = os.getcwd()
os_name = platform.system()
if os_name == "Darwin":
    import zipfile
    import tarfile
elif os_name == "Windows":
    import zipfile
    import subprocess
elif os_name == "Linux":
    import tarfile

class Settings:
    def __init__(self):
        self.dict = {
            "install_path": "",
            "workplace_path": "",
            "gcm": 1,
            "arm_gcc_toolchain": 1,
            "vscode_app": 1,
            "vscode_settings": 1,
            "workplace_reinstall": 1,
            "shortcut": 1,
            "vscode_url": "",
            "arm_gcc_toolchain_url": "",
            "gcm_url": "",
            "clear_cache": "1"
        }
        if os_name == "Darwin":
            self.dict["install_path"] = os.popen("echo $HOME/Applications/").read().rstrip()
            self.dict["workplace_path"] = os.popen("echo $HOME/Documents/").read().rstrip()
            self.dict["vscode_url"] = "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
            self.dict["arm_gcc_toolchain_url"] = "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2"
            self.dict["gcm"] = "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
        elif os_name == "Windows":
            self.dict["install_path"] = os.popen("echo %APPDATA%").read().rstrip()
            self.dict["workplace_path"] = os.popen("echo %USERPROFILE%\\Documents\\").read().rstrip()
            self.dict["vscode_url"] = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
            self.dict["arm_gcc_toolchain_url"] = "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
            self.dict["gcm_url"] = "https://github.com/git-for-windows/git/releases/download/v2.37.3.windows.1/Git-2.37.3-64-bit.exe"
        elif os_name == "Linux":
            self.dict["install_path"] = os.popen("echo $HOME/.local/bin/").read().rstrip()
            self.dict["workplace_path"] = os.popen("echo $HOME/Documents/").read().rstrip()
            self.dict["vscode_url"] = "https://update.code.visualstudio.com/latest/linux-x64/stable"
            self.dict["arm_gcc_toolchain_url"] = "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2"
            self.dict["gcm_url"] = "https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.785/gcm-linux_amd64.2.0.785.deb"
        
    def __str__(self):
        return str(self.dict)

settings = Settings()

def init_folders():
    if not os.path.exists(settings.dict["install_path"]):
        os.makedirs(settings.dict["install_path"])
    if not os.path.exists(settings.dict["install_path"] + "/EPuck2_Utils/"):
        os.makedirs(settings.dict["install_path"] + "/EPuck2_Utils/")
    if not os.path.exists(settings.dict["workplace_path"]):
        os.makedirs(settings.dict["workplace_path"])
     
# Utils installation
def step1():
    os.chdir(settings.dict["install_path"])

    if os_name == "Darwin":    
        Logger.info("Installation of dfu-util, git and git-credential-manager-core")
        os.system("brew tap microsoft/git")
        os.system("brew install dfu-util git")
        if settings.dict["gcm"] == "1":
            os.system("brew --cask git-credential-manager-core")
    elif os_name == "Windows":
        if settings.dict["gcm"] == "1":
            Logger.info("Installation of Git for Windows")
            downloadTo(settings.dict["gcm_url"], "git_setup.exe")
            Logger.warning("Please install git from the external dialog that opens right now")
            subprocess.run("git_setup.exe")
            if settings.dict["clear_cache"] == "1":
                os.remove("git_setup.exe")
        os_copy(origin + "/Universal/gnutools", "EPuck2_Utils/gnutools")
    elif os_name == "Linux":
        Logger.info("Installation of make, dfu-util and git")
        os_cli("sudo apt-get install make dfu-util git")
        if settings.dict["gcm"] == "1":
            Logger.info("Installation of git-credential-manager")
            downloadTo(settings.dict["gcm_url"], "gcm.deb")
            Logger.info("configuring git credential manager")
            os_cli("sudo dpkg -i gcm.deb")
            os_cli("git-credential-manager-core configure")
            os_cli("echo \"[credential]\" >> ~/.gitconfig")
            os_cli("echo \"        credentialStore = secretservice\" >> ~/.gitconfig")
            if settings.dict["clear_cache"] == "1":
                os.remove("gcm.deb")
        os_cli("sudo adduser $USER dialout")
    os_copy(origin + "/Universal/Utils", "EPuck2_Utils/Utils")

def step2():
    os.chdir(settings.dict["install_path"])

    file = None
    src = "vscode.zip"
    dest = "EPuck2_VSCode"         
    if os_name == "Linux":
        src = "vscode.tar.gz"
    elif os_name == "Darwin":
        dest = "EPuck2_VSCode.app"

    if settings.dict["vscode_app"] == "1":
        i = 0
        while i < 2:
            if not os.path.isfile(src):
                downloadTo(settings.dict["vscode_url"], src)
            else:
                Logger.info(f"{src} already exists, not redownloading, delete manualy if file corrupted")
            
            try:
                if os.path.isdir(dest): 
                    Logger.warning("Visual Studio Code already installed, deleting...")
                    shutil.rmtree(dest)

                if os_name == "Linux":
                    file = tarfile.open(src)
                    file.extractall()
                    file.close()
                    shutil.move("VSCode-linux-x64", dest)
                elif os_name == "Darwin":
                    os_cli(f"unzip {src}") #doesn't use the zipfile function cause it looses the file permissions
                    shutil.move("Visual Studio Code.app", dest)
                elif os_name == "Windows":
                    file = zipfile.ZipFile(src, "r")
                    file.extractall(dest)
                    file.close()   
                
                i = 2 #stop the loop
               
                if settings.dict["clear_cache"] == "1":
                    os.remove(src)
        
            except:
                Logger.error(f"Cannot extract {src}, it could have been corrupted")
                os.remove(src)
                if i == 0:
                    i = 1 #give one more chance
                    Logger.info("Retrying...")
                else:
                    i = 2 #stop the loop
                    Logger.error("Max number of try exceeding, skipping...")
    
    if not os.path.isdir(dest): 
        Logger.error("Visual Studio Code not installed!")
    else:
        Logger.info("Visual Studio Code installed!")

# arm_gcc_toolchain installation
def step3():
    os.chdir(settings.dict["install_path"])

    file = None
    src = "arm_gcc_toolchain.tar.bz2"
    dest = "EPuck2_Utils/arm_gcc_toolchain"         
    if os_name == "Windows":
        src = "arm_gcc_toolchain.zip"

    if settings.dict["arm_gcc_toolchain"] == "1":
        i = 0
        while i < 2:
            if not os.path.isfile(src):
                downloadTo(settings.dict["arm_gcc_toolchain_url"], src)
            else:
                Logger.info(f"{src} already exists, not redownloading, delete manualy if file corrupted")
            
            try:
                if os.path.isdir(dest): 
                    Logger.warning("arm_gcc_toolchain already installed, deleting...")
                    shutil.rmtree(dest)

                if os_name == "Windows":
                    file = zipfile.ZipFile(src, "r")
                    file.extractall(dest)
                else:
                    file = tarfile.open(src)
                    file.extractall()
                    shutil.move("gcc-arm-none-eabi-7-2017-q4-major", dest)
               
                file.close()   
                i = 2 #stop the loop
               
                if settings.dict["clear_cache"] == "1":
                    os.remove(src)
        
            except:
                Logger.error(f"Cannot extract {src}, it could have been corrupted")
                os.remove(src)
                if i == 0:
                    i = 1 #give one more chance
                    Logger.info("Retrying...")
                else:
                    i = 2 #stop the loop
                    Logger.error("Max number of try exceeding, skipping...")
    
    if not os.path.isdir(dest): 
        Logger.error("arm_gcc_toolchain not installed!")
    else:
        Logger.info("arm_gcc_toolchain installed!")

if os_name == "Windows":
    make_path = settings.dict["install_path"] + "/EPuck2_Utils/gnutools/make"
    dfu_util = settings.dict["install_path"] + "EPuck2_Utils/dfu-util.exe"
else:
    make_path = "make"
    dfu_util = "dfu-util"
b1 = "\\"
b2 = "\\\\"

json_settings = f'''
{{
    "extensions.autoCheckUpdates": false,
    "extensions.autoUpdate": false,
    "gcc_arm_path": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain",
    "gcc_arm_path_compiler": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin/arm-none-eabi-gcc",
    "make_path": "{make_path.replace(b1, b2)}",
    "epuck2_utils": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/Utils",
    "install_path": "{settings.dict["install_path"].replace(b1, b2)}",
    "workplace": "{settings.dict["workplace_path"].replace(b1, b2)}",
    "terminal.integrated.env.osx": {{
        "PATH": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin:${{env:PATH}}"
    }},
    "terminal.integrated.env.linux": {{
        "PATH": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin:${{env:PATH}}"
    }},
    "terminal.integrated.env.windows": {{
        "PATH": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin;{settings.dict["install_path"]}//EPuck2_Utils//gnutools;${{env:PATH}}"
    }},
    "cortex-debug.armToolchainPath.osx": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin",
    "cortex-debug.armToolchainPath.windows": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin",
    "cortex-debug.armToolchainPath,linux": "{settings.dict["install_path"].replace(b1, b2)}/EPuck2_Utils/arm_gcc_toolchain/bin",
    "version": "{version}"
}}
'''

json_tasks = f'''
{{
    "version": "2.0.0",
    "tasks": [
        {{
            "label": "User:List EPuck2 ports",
            "type": "shell",
            "command": "cd {settings.dict["install_path"]}/EPuck2_Utils/Utils && ./epuck2_port_check.sh",
            "group": {{
                "kind": "build",
                "isDefault": true
            }},
            "presentation": {{
                "echo": false,
            }}
        }},
        {{
            "label": "User:DFU EPuck-2-Main_Processor",
            "type": "shell",
            "command": "{dfu_util} -d 0483:df11 -a 0 -s 0x08000000 -D {settings.dict["install_path"]}/EPuck2_Utils/Utils/e-puck2_main-processor.bin",
            "group": {{
                "kind": "build",
                "isDefault": true
            }},
            "presentation": {{
                "echo": false,
            }}
        }},
        {{
            "label": "User:Run EPuckMonitor",
            "type": "shell",
            "command": "python {settings.dict["install_path"]}/EPuck2_Utils/Utils/monitor.py",
            "group": {{
                "kind": "build",
                "isDefault": true
            }},
            "presentation": {{
                "echo": false,
            }}
        }}
    ]
}}
'''
#TODO: add a clone Lib task

# VSCode configuration
def step4():
    os.chdir(settings.dict["install_path"])

    if settings.dict["vscode_settings"] == "1":
        Logger.info("vscode settings configuration option is selected, proceeding")
        exe = "./code "
        data_dir = settings.dict["install_path"]
        bin_dir = settings.dict["install_path"]
        if os_name == "Darwin":
            data_dir += "/code-portable-data/"
            bin_dir += "/EPuck2_VSCode.app/Contents/Resources/app/bin/"
        elif os_name == "Windows":
            data_dir += "/EPuck2_VSCode/data/"
            bin_dir += "/EPuck2_VSCode/bin/"
            exe = "code.cmd "
        elif os_name == "Linux":
            data_dir += "/EPuck2_VSCode/data/"
            bin_dir += "/EPuck2_VSCode/bin/"
        if os.path.isdir(data_dir):
            Logger.warning("VSCode data_dir already existing, deleting...")
            shutil.rmtree(data_dir)
        os.mkdir(data_dir)
 
        if not os.path.isdir(data_dir): 
            Logger.error("VSCode data_dir not created!")
        else:
            Logger.info("VSCode data_dir created!")

        os.chdir(bin_dir)
        os_cli(exe + "--install-extension marus25.cortex-debug@1.4.4 --force")
        os_cli(exe + "--install-extension ms-vscode.cpptools --force")
        os_cli(exe + "--install-extension forbeslindesay.forbeslindesay-taskrunner --force")
        os_cli(exe + "--install-extension tomoki1207.pdf --force")
        os_cli(exe + "--install-extension mhutchie.git-graph --force")
        #TODO: verification step (extensions successfully installed)

        if not os.path.exists(data_dir + "/user-data/User/"):
            os.makedirs(data_dir + "/user-data/User/")
        os.chdir(data_dir + "/user-data/User/")

        # settings.json
        Logger.info("writting settings.json")
        if os.path.isfile("settings.json"):
            Logger.warning("VSCode settings.json already existing, deleting...")
            os.remove("settings.json")
        file = open("settings.json", "x") #x option for create file, error if already existing
        file.write(json_settings)
        file.close()
        if not os.path.isfile(data_dir + "/user-data/User/settings.json"): 
            Logger.error("VSCode settings.json not created!")
        else:
            Logger.info("VSCode settings.json created!")

        # tasks.json
        Logger.info("writting tasks.json")
        if os.path.isfile("tasks.json"):
            Logger.warning("VSCode tasks.json already existing, deleting...")
            os.remove("tasks.json")
        file = open("tasks.json", "x") #x option for create file, error if already existing
        file.write(json_tasks)
        file.close()
        if not os.path.isfile(data_dir + "/user-data/User/tasks.json"): 
            Logger.error("VSCode tasks.json not created!")
        else:
            Logger.info("VSCode tasks.json created!")

def step5():
    os.chdir(settings.dict["workplace_path"])

    if settings.dict["workplace_reinstall"] == "1":
        print(colored("workplace reinstall option is selected, proceeding", "green"))
        if os.path.isdir("EPuck2_Workplace"):
            if not os_name == "Windows":
                shutil.rmtree("EPuck2_Workplace")
            else:
                os_cli("rmdir /s EPuck2_Workplace")
        os.mkdir("EPuck2_Workplace/")
        os.chdir("EPuck2_Workplace/")
        os_cli("git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git Lib")

        folder = "Lib/e-puck2_main-processor/aseba/clients/studio/plugins/ThymioBlockly/blockly/"
        if os.path.isfile(folder + "package.json"):
            os.rename(folder + "package.json", folder + "package.json-renamed-because-conflict-task-tp-4")
        #TODO: verification step (Lib actually cloned)

def step6():
    if settings.dict["shortcut"] == "1":
        print(colored("shortcut creation selected, proceeding", "green"))
        if os_name == "Windows":
            os.chdir(settings.dict["install_path"] + "/EPuck2_VSCode")
            os.system(f"cmd.exe /c \"start {origin}/Universal/shortcut.bat\"")
        elif os_name == "Linux":
            os.chdir(settings.dict["install_path"] + "/EPuck2_VSCode")
            desktop_file = f'''
            [Desktop Entry]
            Type=Application
            Terminal=false
            Name=Visual Studio Code EPuck2
            Exec={settings.dict["install_path"]}/EPuck2_VSCode/code
            Icon={settings.dict["install_path"]}/EPzck2_VSCode/resources/app/resources/linux/code.png
            '''
            os.chdir(os.popen("echo $HOME/Desktop").read().rstrip())
            file = open("vscode_epuck2.desktop")
            file.write(desktop_content)
            file.close()
            # According to https://www.how2shout.com/linux/allow-launching-linux-desktop-shortcut-files-using-command-terminal/
            os_cli("gio set $FILE metadata::trusted true")  # Mark the shortcut status trusted
            os_cli("chmod u+x $FILE") # Then allow execution
