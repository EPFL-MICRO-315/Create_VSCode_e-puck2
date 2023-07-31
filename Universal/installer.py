import os
import sys
import time
import platform
import shutil
from termcolor import colored
from utils import *

os_name = platform.system()
if os_name == "Darwin":
    import zipfile
    import tarfile
elif os_name == "Windows":
    import zipfile
    import subprocess
elif os_name == "Linux": import tarfile
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
            "gcm_url": ""
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
        #TODO: check if brew installed
        print(colored("Installation of brew, dfu-util, git and git-credential-manager-core", "green"))
        os.system(settings.dict["gcm_url"])
        os.system("brew tap microsoft/git")
        os.system("brew install dfu-util git")
        if settings.dict["gcm"] == 1:
            os.system("brew --cask git-credential-amanger-core")
        os_copy(origin + "/Utils", "EPuck2_Utils/Utils")
    elif os_name == "Windows":
        if settings.dict["gcm"] == 1:
            print(colored("Installation of Git for Windows", "green"))
            downloadTo(settings.dict["gcm_url"], "git_setup.exe")
            print(colored("Please install git from the external dialog that opens right now", "yellow"))
            subprocess.run("git_setup.exe")
        os_copy(origin + "/gnutools", "EPuck2_Utils/gnutools")
        os_copy(origin + "/Utils", "EPuck2_Utils/Utils")

    elif os_name == "Linux":
        print(colored("Installation of make, dfu-util and git", "green"))
        os.system("sudo apt-get install make dfu-util git")
        if settings.dict["gcm"] == 1:
            print(colored("Installation of git-credential-manager", "green"))
            downloadTo(settings.dict["gcm_url"], "gcm.deb")
            os_cli("sudo dpkg -i gcm.deb")
            os_cli("git-credential-manager-core configure")
            os_cli("echo \"[credential]\" >> ~/.gitconfig")
            os_cli("echo \"        credentialStore = secretservice\" >> ~/.gitconfig")
        os_copy(origin + "/Utils", "EPuck2_Utils/Utils")

# VSCode installation
def step2():
    os.chdir(settings.dict["install_path"])

    file = None
    if settings.dict["vscode_app"]:
        if os_name == "Darwin":
            downloadTo(settings.dict["vscode_url"], "vscode.zip")
            with zipfile.ZipFile("vscode.zip", "r") as file:
                file.extractall("EPuck2_VSCode.app")
        elif os_name == "Windows":
            downloadTo(settings.dict["vscode_url"], "vscode.zip")
            with zipfile.ZipFile("vscode.zip", "r") as file:
                file.extractall("EPuck2_VSCode")
        elif os_name == "Linux":
            downloadTo(settings.dict["vscode_url"], "vscode.tar.gz")
            file = tarfile.open("vscode.tar.gz")
            file.extractall("EPuck2_VSCode")
        file.close()
        #TODO: verification step
        print(colored("Visual Studio Code installed", "green"))

# arm_gcc_toolchain installation
def step3():
    os.chdir(settings.dict["install_path"])

    file = None
    if settings.dict["arm_gcc_toolchain"]:
        if os_name == "Darwin":
            downloadTo(settings.dict["arm_gcc_toolchain_url"], "arm_gcc_toolchain.tar.bz2")
            with zipfile.ZipFile("arm_gcc_toolchain.tar.bz2", "r") as file:
                file.extractall("EPuck2_Utils")
        elif os_name == "Windows":
            downloadTo(settings.dict["arm_gcc_toolchain_url"], "arm_gcc_toolchain.zip")
            with zipfile.ZipFile("arm_gcc_toolchain.zip", "r") as file:
                file.extractall("EPuck2_Utils")
        elif os_name == "Linux":
            downloadTo(settings.dict["arm_gcc_toolchain_url"], "arm_gcc_toolchain.tar.bz2")
            file = tarfile.open("arm_gcc_toolchain.tar.bz2")
            file.extractall("EPuck2_Utils")
            file.close()
        #TODO: verification step
        print(colored("arm_gcc_toolchain installed", "green"))

#TODO:
json_settings = f'''
{
    "extensions.autoCheckUpdates": false,
    "extensions.autoUpdate": false,
    "gcc_arm_path": {settings.dict["install_path"]}/EPuck2_Utils/gcc-arm-none-eabi-7-2017-q4-major,
    "gcc_arm_path_compiler": {settings.dict["install_path"]}/EPuck2_Utils/gcc-arm-none-eabi-7-2017-q4-major/bin/arm-none-eabi-gcc,
    "make_path": {settings.dict["install_path"]}/EPuck2_Utils/gnutools/make,
    "epuck2_utils": {settings.dict["install_path"]}/EPuck2_Utils/Utils,
    "install_path": {settings.dict["install_path"]},
    "workplace": {settings.dict["workplace_path"]},
    "terminal.integrated.env.{}": {
        "PATH": "{settings.dict["install_path"]}/EPuck_Utils/gcc-arm_toolchain/bin:$\{env:PATH}"
    },
    "version": {}
}
'''

json_tasks = '''
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "User:List EPuck2 ports",
            "type": "shell",
            "command": "cd ${config:epuck2_utils} && ./epuck2_port_check.sh",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": false,
            }
        },
       {
            "label": "User:DFU EPuck-2-Main_Processor",
            "type": "shell",
            "command": "dfu-util -d 0483:df11 -a 0 -s 0x08000000 -D ${config:epuck2_utils}//e-puck2_main-processor.bin",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": false,
            }
        },
        {
            "label": "User:Run EPuckMonitor",
            "type": "shell",
            "command": "python ${config:epuck2_utils}//monitor",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": false,
            }
        }
    ]
}
'''
#TODO: add a clone Lib task

# VSCode configuration
def step4():
    os.chdir(settings.dict["install_path"])

    if settings.dict["vscode_settings"]:
        print(colored("vscode settings configuration option is selected, proceeding", "green"))
        exe = "./code "
        data_dir = ""
        bin_dir = ""
        if os_name == "Darwin":
            data_dir = "code-portable-data/"
            shutil.rmtree(data_dir)
            bin_dir = "EPuck2_VSCode.app/Contents/Resources/app/bin/"
        elif os_name == "Windows" or os_name == "Linux":
            data_dir = "EPuck2_VSCode/data/"
            shutil.rmtree(data_dir)
            bin_dir = "EPuck2_VSCode/bin/"
            if os_name == "Windows":
                exe = "code.exe "
        os.mkdir(data_dir)
        #TODO: verifshutilication step (data_dir successfully created)

        os.chdir(bin_dir)
        os_cli(exe + "--install-extension marus25.cortex-debug@1.4.4 --force")
        os_cli(exe + "--install-extension ms-vscode.cpptools --force")
        os_cli(exe + "--install-extension forbeslindesay.forbeslindesay-taskrunner --force")
        os_cli(exe + "--install-extension tomoki1207.pdf --force")
        os_cli(exe + "--install-extension git-graph.4.4 --force")
        #TODO: verification step (extensions successfully installed)

        print(colored("writting settings.json", "green"))
        os.chdir(settings.dict["install_path"] + data_dir + "data/user-data/User/")
        file = open("settings.json")
        file.write(settings_json)
        file.close()

        print(colored("writting tasks.json", "green"))
        file = open("tasks.json")
        file.write(tasks_json)
        file.close()

def step5():
    os.chdir(settings.dict["workplace_path"])

    if settings.dict["workplace_reinstall"]:
        print(colored("workplace reinstall option is selected, proceeding", "green"))
        shutil.rmtree("EPuck2_Workplace/")
        os.mkdir("EPuck2_Workplace/")
        os.chdir("EPuck2_Workplace/")
        os_cli("git clone --recurse-submodules https://github.com/EPFL-MICRO-315/Lib_VSCode_e-puck2.git Lib")
        #TODO: tyhmio blocky package json
        #TODO: verification step (Lib actually cloned)
