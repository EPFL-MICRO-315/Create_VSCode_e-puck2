import os
import sys
import time
import platform
import shutil
from termcolor import colored
import utils


os_name = platform.system()
if os_name == "Darwin":
    import zipfile
    import tarfile
elif os_name == "Windows":
    import zipfile
elif os_name == "Linux":
    import tarfile

class Settings:
    def __init__(self):
        self.dict = {
            "install_path": "",
            "workspace_path": "",
            "gcm": 1,
            "arm_gcc_toolchain": 1,
            "vscode_app": 1,
            "vscode_settings": 1,
            "workspace_reinstall": 1,
            "shortcut": 1,
            "vscode_url": "",
            "arm_gcc_toolchain_url": ""
        }
        if os_name == "Darwin":
            self.dict["install_path"] = ""
            self.dict["workspace_path"] = ""
            self.dict["vscode_url"] = "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"
            self.dict["arm_gcc_toolchain_url"] = "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2"
        elif os_name == "Windows":
            self.dict["install_path"] = ""
            self.dict["workspace_path"] = ""
            self.dict["vscode_url"] = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
            self.dict["arm_gcc_toolchain_url"] = "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip"
        elif os_name == "Linux":
            self.dict["install_path"] = ""
            self.dict["workspace_path"] = ""
            self.dict["vscode_url"] = "https://update.code.visualstudio.com/latest/linux-x64/stable"
            self.dict["arm_gcc_toolchain_url"] = "https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2"
        
    def __str__(self):
        return self.dict

settings = Settings()

# Utils installation
def step1():
    if os_name == "Darwin":    
        print(colored("Installation of brew, dfu-util, git and git-credential-manager-core", "green"))
        os.system("curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh")
        os.system("brew tap microsoft/git")
        os.system("brew install dfu-util git")
        if settings.gcm:
            os.system("brew --cask git-credential-amanger-core")
        #TODO: verification step
    elif os_name == "Windows":
        if settings.gcm:
            print(colored("Installation of Git for Windows", "green"))
            utils.downloadTo("https://github.com/git-for-windows/git/releases/download/v2.37.3.windows.1/Git-2.37.3-64-bit.exe", "git_setup.exe")
            print(colored("Please install git from the external dialog that opens right now\n It could take some seconds to be displayed and it could be hidden behind this terminal window", "yellow"))
            os.system("cmd git_setup.exe /SILENT")
        #TODO: verification step
    elif os_name == "Linux":
        print(colored("Installation of make, dfu-util and git", "green"))
        os.system("sudo apt-get install make dfu-util git")
        if settings.gcm:
            print(colored("Installation of git-credential-manager", "green"))
            utils.downloadTo("https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.785/gcm-linux_amd64.2.0.785.deb", "gcm.deb")
            os.system("sudo dpkg -i gcm.deb")
            os.system("git-credential-manager-core configure")
            os.system("echo \"[credential]\" >> ~/.gitconfig")
            os.system("echo \"        credentialStore = secretservice\" >> ~/.gitconfig")
        #TODO: verification step

# VSCode installation
def step2():
    file = None
    if settings.vscode_app:
        if os_name == "Darwin":
            utils.downloadTo(settings.vscode_mac_url, "vscode.zip")
            with zipfile.ZipFile("vscode.zip", "r") as file:
                file.extractall(settings.install_path + "/EPuck2_VSCode.app")
        elif os_name == "Windows":
            utils.downloadTo(settings.vscode_windows_url, "vscode.zip")
            with zipfile.ZipFile("vscode.zip", "r") as file:
                file.extractall(settings.install_path + "/EPuck2_VSCode")
        elif os_name == "Linux":
            utils.downloadTo(settings.vscode_linux_url, "vscode.tar.gz")
            file = tarfile.open("vscode.tar.gz")
            file.extractall(settings.install_path + "/EPuck2_VSCode")
            file.close()
        #TODO: verification step
        print(colored("Visual Studio Code installed", "green"))

# arm_gcc_toolchain installation
def step3():
    file = None
    if settings.arm_gcc_toolchain:
        if os_name == "Darwin":
            utils.downloadTo(settings.arm_gcc_toolchain_mac_url, "arm_gcc_toolchain.tar.bz2")
            with zipfile.ZipFile("arm_gcc_toolchain.tar.bz2", "r") as file:
                file.extractall(settings.install_path "/EPuck2_Utils")
        elif os_name == "Windows":
            utils.downloadTo(settings.arm_gcc_toolchain_windows_url, "arm_gcc_toolchain.zip")
            with zipfile.ZipFile("arm_gcc_toolchain.zip", "r") as file:
                file.extractall(settings.install_path + "/EPuck2_Utils")
        elif os_name == "Linux":
            utils.downloadTo(settings.arm_gcc_toolchain_linux_url, "arm_gcc_toolchain.tar.bz2")
            file = tarfile.open("arm_gcc_toolchain.tar.bz2")
            file.extractall(settings.install_path + "/EPuck2_Utils")
            file.close()
        #TODO: verification step
        print(colored("arm_gcc_toolchain installed", "green"))

# VSCode configuration
def step4():
    if settings.vscode_settings:
        exe = "./code "
        if os_name == "Darwin":
            shutil.rmtree(settings.install_path + "/code-portable-data")
            os.mkdir(settings.install_path + "/code-portable-data")
            os.chdir("." + settings.install_path + "EPuck2_VSCode.app/Contents/Resources/app/bin")
        elif os_name == "Windows" or os_name == "Linux":
            shutil.rmtree(settings.install_path + "/EPuck2_VSCode/data")
            os.mkdir(settings.install_path + "/EPuck2_VSCode/data")
            os.chdir("." + settings.install_path + "EPuck2_VSCode/bin")
            if os_name == "Windows":
                exe = "code.exe "
        os.system(exe + "--install-extension marus25.cortex-debug@1.4.4 --force")
        os.system(exe + "--install-extension ms-vscode.cpptools --force")
        os.system(exe + "--install-extension forbeslindesay.forbeslindesay-taskrunner --force")
        os.system(exe + "--install-extension tomoki1207.pdf --force")
        os.system(exe + "--install-extension git-graph.4.4 --force")


