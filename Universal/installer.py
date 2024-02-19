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

import os, stat
from os.path import expanduser
import sys
import time
import platform
import shutil
import logging
import distro
from utils import *

def remove_readonly(func, path, _):
    "Clear the readonly bit and reattempt the removal"
    os.chmod(path, stat.S_IWRITE)
    func(path)

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

settings = {}

b1 = "\\"
b2 = "/"

def init_folders():
    logging.warning("Creating folders")
    if not os.path.exists(settings["install_path"]):
        os.makedirs(settings["install_path"])
    if not os.path.exists(settings["install_path"] + "/EPuck2_Utils/"):
        os.makedirs(settings["install_path"] + "/EPuck2_Utils/")
    if not os.path.exists(settings["workplace_path"]):
        os.makedirs(settings["workplace_path"])
    if not os.path.exists(settings["workplace_path"] + "/EPuck2_Workplace/"):
        os.makedirs(settings["workplace_path"] + "/EPuck2_Workplace/")
        os.chdir(settings["workplace_path"] + "/EPuck2_Workplace/")
        os.system("pyenv local e-puck2")
    
# Tools installation
def step0():
    os.chdir(settings["install_path"])
    logging.warning("Tools installation")
    
    if os_name == "Darwin":    
        logging.info("Installation of dfu-util, git")
        os.system("brew install dfu-util git")
    elif os_name == "Windows":
        os_copy(origin + "/Universal/gnutools", "EPuck2_Utils/gnutools")
    elif os_name == "Linux":
        logging.info("Installation of make, dfu-util and git")
        if distro.id() == "ubuntu":
            os_cli("sudo apt-get -y install dfu-util")
            os_cli("sudo adduser $USER dialout")
        elif distro.id() == "fedora":
            os_cli("sudo dnf -y install dfu-util")
            os_cli("sudo usermod -aG dialout $USER")
    os_copy(origin + "/Universal/Utils", "EPuck2_Utils/Utils")
    
# Github Credential Manager installation
def step1():
    os.chdir(settings["install_path"])
    logging.warning("Installation of git-credential-manager")
        
    if os_name == "Darwin":
        logging.warning("Enter your password requested on terminal")
        os.system("brew install --cask git-credential-manager")
        os.system("git config --global credential.credentialStore keychain")
    elif os_name == "Windows":
        downloadTo(settings["gcm_url"], "git_setup.exe")
        logging.warning("Please check git installation in the external dialog that opens right now")
        subprocess.run("git_setup.exe /SILENT")
        if settings["clear_cache"]:
            os.remove("git_setup.exe")
    elif os_name == "Linux":
        downloadTo(settings["gcm_url"], "gcm.deb")
        os_cli("sudo dpkg -i gcm.deb")
        os_cli("git-credential-manager configure")
        os_cli("git config --global credential.credentialStore secretservice") # might need to logout and login again
        os_cli("git config --global pull.rebase false")
        if settings["clear_cache"]:
            os.remove("gcm.deb")

# Visual Studio Code installation
def step2():
    os.chdir(settings["install_path"])
    logging.warning("Installation of VSCode")
    
    src = "vscode.zip"
    dest = "EPuck2_VSCode"         
    if os_name == "Linux":
        src = "vscode.tar.gz"
    elif os_name == "Darwin":
        dest = "EPuck2_VSCode.app"

    for attempt in range(2):
        downloadTo(settings["vscode_url"], src)
        
        try:
            if os.path.isdir(dest): 
                logging.warning(f"Visual Studio Code installation in {settings['install_path']} detected, deleting...")
                shutil.rmtree(dest, onerror=remove_readonly)

            if os_name == "Linux":
                with tarfile.open(src) as file:
                    file.extractall()
                shutil.move("VSCode-linux-x64", dest)
            elif os_name == "Darwin":
                os_cli(f"unzip {src}") #doesn't use the zipfile function cause it looses the file permissions
                shutil.move("Visual Studio Code.app", dest)
            elif os_name == "Windows":
                with zipfile.ZipFile(src, "r") as file:
                    file.extractall(dest)
            
            if settings["clear_cache"]:
                os.remove(src)
    
            break #stop the loop if no error occured

        except Exception as e:
            logging.error(f"Cannot extract {src}, it could have been corrupted. Error: {str(e)}")
            os.remove(src)
            if attempt == 0:
                logging.info("Retrying...")
            else:
                logging.fatal("Max number of try exceeding, skipping...")
                    
    if not os.path.isdir(dest): 
        logging.fatal("Visual Studio Code not installed!")
    else:
        logging.info("Visual Studio Code is installed!")

# arm_gcc_toolchain installation
def step3():
    os.chdir(settings["install_path"])
    logging.warning("Installation of arm_gcc_toolchain")

    src = "arm_gcc_toolchain.tar.bz2"
    dest = "EPuck2_Utils/arm_gcc_toolchain"         
    if os_name == "Windows":
        src = "arm_gcc_toolchain.zip"

    for attempt in range(2):
        downloadTo(settings["arm_url"], src)
        
        try:
            if os.path.isdir(dest): 
                logging.warning(f"arm_gcc_toolchain installation in {settings['install_path']} detected, deleting...")
                shutil.rmtree(dest, onerror=remove_readonly)

            if os_name == "Windows":
                with zipfile.ZipFile(src, "r") as file:
                    file.extractall(dest)
            else:
                with tarfile.open(src) as file:
                    file.extractall()
                shutil.move("gcc-arm-none-eabi-7-2017-q4-major", dest)
            
            file.close()
            
            if settings["clear_cache"]:
                os.remove(src)
    
            break #stop the loop if no error occured

        except Exception as e:
            logging.error(f"Cannot extract {src}, it could have been corrupted. Error: {str(e)}")
            os.remove(src)
            if attempt == 0:
                logging.info("Retrying...")
            else:
                logging.error("Max number of try exceeding, skipping...")
    
    if not os.path.isdir(dest): 
        logging.fatal("arm_gcc_toolchain not installed!")
    else:
        logging.info("arm_gcc_toolchain installed!")

# EPuck2 Monitor installation
def step4():
    os.chdir(settings["install_path"] + "/EPuck2_Utils/")
    dest = "Monitor/"         
    
    if os_name == "Windows":
        src = "monitor_win.zip"
    elif os_name == "Darwin":
        src = "monitor_mac.zip"
        dest = "EPuckMonitor.app"
    elif os_name == "Linux":
        src = "monitor_linux64bit.tar.gz"
        
    for attempt in range(2):
        downloadTo(settings["monitor_url"], src)
        
        try:
            if os.path.isdir(dest): 
                logging.warning(f"EPuck 2 monitor installation in {settings['install_path']}/Epuck2_Utils/ detected, deleting...")
                shutil.rmtree(dest, onerror=remove_readonly)

            if os_name == "Darwin":
                with zipfile.ZipFile(src, "r") as file:
                    file.extractall()
                os_cli("chmod +x EPuckMonitor.app/Contents/MacOS/EPuckMonitor")
            elif os_name == "Linux":
                with tarfile.open(src) as file:
                    file.extractall()
                shutil.move("build-qmake-Desktop_Qt_5_10_1_GCC_64bit-Release", dest)
            else:
                with zipfile.ZipFile(src, "r") as file:
                    file.extractall()
                shutil.move("build-qmake-Desktop_Qt_5_10_0_MinGW_32bit-Release", dest)
                
            file.close()
            
            if settings["clear_cache"]:
                os.remove(src)
    
            break #stop the loop if no error occured

        except Exception as e:
            logging.error(f"Cannot extract {src}, it could have been corrupted. Error: {str(e)}")
            os.remove(src)
            if attempt == 0:
                logging.info("Retrying...")
            else:
                logging.error("Max number of try exceeding, skipping...")
    
    if not os.path.isdir(dest): 
        logging.fatal("EPuck monitor not installed!")
    else:
        logging.info("EPuck monitor installed!")

# VSCode configuration
def step5():
    if os_name == "Windows":
        make_path = settings["install_path"].replace(b1, b2) + "/EPuck2_Utils/gnutools/make"
        dfu_util = settings["install_path"].replace(b1, b2) + "/EPuck2_Utils/dfu-util.exe"
    else:
        make_path = "make"
        dfu_util = "dfu-util"

    json_settings = f'''
{{
    "window.title": "${{dirty}}${{activeEditorShort}}${{separator}}${{rootName}}${{separator}}${{profileName}}${{separator}}Visual Studio Code E-Puck2",
    "extensions.autoCheckUpdates": false,
    "extensions.autoUpdate": false,
    "editor.parameterHints.enabled": false,
    "gcc_arm_path": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain",
    "gcc_arm_path_compiler": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin/arm-none-eabi-gcc",
    "make_path": "{make_path.replace(b1, b2)}",
    "epuck2_utils": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/Utils",
    "install_path": "{settings["install_path"].replace(b1, b2)}",
    "workplace": "{settings["workplace_path"].replace(b1, b2)}",
    "terminal.integrated.env.osx": {{
        "PATH": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin:${{env:PATH}}"
    }},
    "terminal.integrated.env.linux": {{
        "PATH": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin:${{env:PATH}}"
    }},
    "terminal.integrated.env.windows": {{
        "PATH": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin;{settings["install_path"].replace(b1, b2)}EPuck2_Utils/gnutools;${{env:PATH}}"
    }},
    "terminal.integrated.defaultProfile.windows": "Git Bash",
    "cortex-debug.armToolchainPath.osx": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin",
    "cortex-debug.armToolchainPath.windows": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin",
    "cortex-debug.armToolchainPath,linux": "{settings["install_path"].replace(b1, b2)}EPuck2_Utils/arm_gcc_toolchain/bin",
    "version": "{version}"
}}
    '''
    if os_name == "Darwin":
        monitor_cmd = "${config:install_path}EPuck2_Utils/EPuckMonitor.app/Contents/MacOS/EPuckMonitor"
    elif os_name == "Windows":
        monitor_cmd = "${config:install_path}EPuck2_Utils/Monitor/EPuckMonitor.exe"
    elif os_name == "Linux":
        monitor_cmd = "cd ${config:install_path}EPuck2_Utils/Monitor && ./EPuckMonitor"
        
    json_tasks = f'''
{{
    "version": "2.0.0",
    "tasks": [
        {{
            "label": "User:List EPuck2 ports",
            "type": "shell",
            "command": "cd {settings["install_path"].replace(b1, b2)}EPuck2_Utils/Utils && ./epuck2_port_check.sh",
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
            "command": "{dfu_util} -d 0483:df11 -a 0 -s 0x08000000 -D {settings["install_path"].replace(b1, b2)}EPuck2_Utils/Utils/e-puck2_main-processor.bin",
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
            "command": "{monitor_cmd}",
            "group": {{
                "kind": "build",
                "isDefault": true
            }},
            "presentation": {{
                "echo": false,
            }}
        }},
        {{
            "label": "User:Clone Lib",
            "type": "shell",
            "command": "rm -rf {settings["workplace_path"].replace(b1, b2)}EPuck2_Workplace/Lib && git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git {settings["workplace_path"].replace(b1, b2)}EPuck2_Workplace/Lib",
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

    os.chdir(settings["install_path"])
    logging.warning("Configuration of VSCode (settings and user tasks)")
    
    exe = "./code "
    data_dir = settings["install_path"]
    bin_dir = settings["install_path"]
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
        logging.warning(f"VSCode data_dir detected in {settings['install_path']}, deleting...")
        shutil.rmtree(data_dir, onerror=remove_readonly)
    os.mkdir(data_dir)

    if not os.path.isdir(data_dir): 
        logging.error("VSCode data_dir not created!")
    else:
        logging.info("VSCode data_dir created!")

    os.chdir(bin_dir)
    os_cli(exe + "--install-extension marus25.cortex-debug@1.4.4 --force")
    os_cli(exe + "--install-extension ms-vscode.cpptools --force")
    os_cli(exe + "--install-extension forbeslindesay.forbeslindesay-taskrunner --force")
    os_cli(exe + "--install-extension tomoki1207.pdf --force")
    os_cli(exe + "--install-extension mhutchie.git-graph --force")
    
    if not os.path.exists(data_dir + "/user-data/User/"):
        os.makedirs(data_dir + "/user-data/User/")
    os.chdir(data_dir + "/user-data/User/")

    # settings.json
    logging.info("writting settings.json")
    if os.path.isfile("settings.json"):
        logging.warning("VSCode settings.json already existing, deleting...")
        os.remove("settings.json")
    try:
        with open("settings.json", "x") as file: #x option for create file, error if already existing
            file.write(json_settings)
    except Exception as e:
        logging.error(f"Error writing to settings.json: {str(e)}")

    if not os.path.isfile(data_dir + "/user-data/User/settings.json"): 
        logging.error("VSCode settings.json not created!")
    else:
        logging.info("VSCode settings.json created!")

    # tasks.json
    logging.info("writting tasks.json")
    if os.path.isfile("tasks.json"):
        logging.warning("VSCode tasks.json already existing, deleting...")
        os.remove("tasks.json")
    try:
        with open("tasks.json", "x") as file: #x option for create file, error if already existing
            file.write(json_tasks)
    except Exception as e:
        logging.error(f"Error writing to tasks.json: {str(e)}")

    if not os.path.isfile(data_dir + "/user-data/User/tasks.json"): 
        logging.error("VSCode tasks.json not created!")
    else:
        logging.info("VSCode tasks.json created!")

def step6():
    folder = settings["workplace_path"].replace(b1, b2) + "/EPuck2_Workplace"
    os.chdir(folder)
    logging.warning(f"Setting up the Workplace Lib in {folder}")
    
    if os.path.isdir("Lib"):
        logging.warning(f"{folder}/Lib is already existing. Nothing else the Lib subfolder will be touched.")
        # input(f"Before removing {folder}/Lib: Press any key to continue ...")
        shutil.rmtree("Lib", onerror=remove_readonly)
        # input(f"After removing {folder}/Lib: Press any key to continue ...")

    logging.info(f"Cloning the lib in {folder}")
    os_cli("git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git Lib")

    if not os.path.isfile(folder+"/Lib/README.md"): #check if Lib was correctly cloned 
        logging.error("Lib not correctly cloned!")
    else:
        folder = "Lib/e-puck2_main-processor/aseba/clients/studio/plugins/ThymioBlockly/blockly/"
        if os.path.isfile(folder + "package.json"):
            os.rename(folder + "package.json", folder + "package.json-RenamedToAvoidBadTasksInVSCode")
            logging.info("Lib sucessfully cloned!")
        else:
            logging.warning("Lib must be checked: package.json file not in Aseba")

def step7():
    logging.warning("shortcut creation selected, proceeding")
    
    if os_name == "Windows":
        os.chdir(settings["install_path"] + "/EPuck2_VSCode")
        os.system(f"cmd.exe /c \"start {origin}/Universal/shortcut.bat\"")
    elif os_name == "Linux":
        desktop_file = f'''
[Desktop Entry]
Type=Application
Terminal=false
Name=Visual Studio Code EPuck2
Exec={settings["install_path"].replace(b1, b2)}EPuck2_VSCode/code
Icon={settings["install_path"].replace(b1, b2)}EPuck2_VSCode/resources/app/resources/linux/code.png
Catergories=Development;IDE;
        '''
        os.chdir(os.popen("echo $HOME/.local/share/applications").read().rstrip())
        filename = "vscode_epuck2.desktop"
        with open(filename, "w+") as file:
            file.write(desktop_file)
        # According to https://www.how2shout.com/linux/allow-launching-linux-desktop-shortcut-files-using-command-terminal/
        os_cli(f"set {filename} metadata::trusted true")  # Mark the shortcut status trusted
        os_cli(f"chmod u+x {filename}") # Then allow execution
