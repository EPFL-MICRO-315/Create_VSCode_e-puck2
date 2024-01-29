from PyQt5 import QtCore, QtGui, QtWidgets
import logging
import time
import platform

os_name = platform.system()
fields = [ 'install_path', 'workplace_path', 'vscode', 'vscode_settings', 'arm', 'gcm', 'workplace', 'shortcut', 'clear_cache', 'vscode_url', 'arm_url', 'gcm_url' ]
        
class ClassWizard(QtWidgets.QWizard):
    def __init__(self, parent=None):
        super(ClassWizard, self).__init__(parent)

        self.addPage(IntroPage())
        self.addPage(SetupPage())
        self.addPage(AdvancedSetupPage())
        self.addPage(ProceedPage())
        self.addPage(InstallPage())
        
        px = QtGui.QPixmap('e-puck2.png')
        px = px.scaled(250, 250, QtCore.Qt.KeepAspectRatio);
        self.setPixmap(QtWidgets.QWizard.WatermarkPixmap, px)
        
        self.setWindowTitle("VSCode EPuck2 Setup")
        self.WizardStyle = QtWidgets.QWizard.ClassicStyle
        
    def accept(self):
        super(ClassWizard, self).accept()


class IntroPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(IntroPage, self).__init__(parent)

        self.setTitle("Welcome to the VSCode EPuck2 Setup Wizard")        

        label = QtWidgets.QLabel("This wizard will install on this computer a copy of VSCode EPuck 2 IDE.\n"
                "This software includes the editor (VSCode) with pre-installed extensions, "
                "it also includes the ARM toolchain (compiler and debugger).")
        label.setWordWrap(True)

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(label)
        self.setLayout(layout)


class SetupPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(SetupPage, self).__init__(parent)

        installPath = str(QtCore.QDir.homePath() + "/.local/bin")
        installPathEdit = QtWidgets.QLineEdit(installPath)
        def installPath_dialog():
            nonlocal installPath
            installPath = installPathEdit.text()
            tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", installPath)
            if tmp != "":
                installPath = tmp
            installPathEdit.setText(installPath)

        workplacePath = str(QtCore.QDir.homePath() + "/Documents/")
        workplacePathEdit = QtWidgets.QLineEdit(workplacePath)
        def workplacePath_dialog():
            nonlocal workplacePath
            workplacePath = workplacePathEdit.text()
            tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", workplacePath)
            if tmp != "":
                workplacePath = tmp
            workplacePathEdit.setText(workplacePath)


        self.setTitle("Custom the setup")     
        self.setSubTitle("Specify in more details where you want the wizard to setup the IDE")


        installPathBox = QtWidgets.QGroupBox("Install Path:")
        installPathButton = QtWidgets.QPushButton('...')
        installPathButton.clicked.connect(installPath_dialog)
        installPathDescription = QtWidgets.QLabel("Where the IDE and its components will be stored")
        
        installPathBoxL = QtWidgets.QGridLayout()
        installPathBoxL.addWidget(installPathDescription, 0, 0, 1, 2)
        installPathBoxL.addWidget(installPathEdit)
        installPathBoxL.addWidget(installPathButton)        
        installPathBox.setLayout(installPathBoxL);
        
        workplacePathBox = QtWidgets.QGroupBox("Workplace Path:")
        workplacePathButton = QtWidgets.QPushButton('...')
        workplacePathButton.clicked.connect(workplacePath_dialog)
        workplacePathDescription = QtWidgets.QLabel("Where the librairies, exercises and your project will be stored")
        
        workplacePathBoxL = QtWidgets.QGridLayout()
        workplacePathBoxL.addWidget(workplacePathDescription, 0, 0, 1, 2)
        workplacePathBoxL.addWidget(workplacePathEdit, 1, 0)
        workplacePathBoxL.addWidget(workplacePathButton, 1, 1)       
        workplacePathBox.setLayout(workplacePathBoxL);

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(installPathBox)
        layout.addWidget(workplacePathBox)
        self.setLayout(layout)

        # registerField functions are used to let other pages accessing the specfied variable with user defined key
        self.registerField('install_path', installPathEdit)
        self.registerField('workplace_path', workplacePathEdit)

class AdvancedSetupPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(AdvancedSetupPage, self).__init__(parent)

        self.setTitle("Custom the setup (Advanced)")     
        self.setSubTitle("Specify in more details what component you want the wizard to setup\n"
                         "Do not modify unless you know what you are doing!")
        
        checkBox = QtWidgets.QGroupBox("Components selection")
        vscode          = QtWidgets.QCheckBox("(re)install VSCode ?")
        vscode_settings = QtWidgets.QCheckBox("(re) VSCode settings?")
        arm             = QtWidgets.QCheckBox("(re)install ARM toolchain ?")
        gcm             = QtWidgets.QCheckBox("(re)install GCM (Github Credential Manager) ?")
        workplace       = QtWidgets.QCheckBox("(re)install workplace ?")
        shortcut        = QtWidgets.QCheckBox("(re)create shortcut ?")
        clear_cache     = QtWidgets.QCheckBox("Clear cache after installation ?")

        vscode.setChecked(True)
        vscode_settings.setChecked(True)
        arm.setChecked(True)
        gcm.setChecked(True)
        workplace.setChecked(True)
        shortcut.setChecked(True)
        clear_cache.setChecked(True)

        checkBoxL = QtWidgets.QVBoxLayout()
        checkBoxL.addWidget(vscode)
        checkBoxL.addWidget(vscode_settings)
        checkBoxL.addWidget(arm)
        checkBoxL.addWidget(gcm)
        checkBoxL.addWidget(workplace)
        checkBoxL.addWidget(shortcut)
        checkBoxL.addWidget(clear_cache) 
        checkBoxL.addStretch(1)
        checkBox.setLayout(checkBoxL);
    
        urlBox = QtWidgets.QGroupBox("Download URLs")
        vscode_urlDescription = QtWidgets.QLabel("VSCode download URL:")
        vscode_urlEdit = QtWidgets.QLineEdit()
        arm_urlDescription = QtWidgets.QLabel("ARM Toolchain download URL:")
        arm_urlEdit = QtWidgets.QLineEdit()
        gcm_urlDescription = QtWidgets.QLabel("GCM (Github Credential Manager) download command:")
        gcm_urlEdit = QtWidgets.QLineEdit()
        
        self.registerField('vscode',          vscode)
        self.registerField('vscode_settings', vscode_settings)
        self.registerField('arm',             arm)
        self.registerField('gcm',             gcm)
        self.registerField('workplace',       workplace)
        self.registerField('shortcut',        shortcut)
        self.registerField('clear_cache',     clear_cache)
        self.registerField('vscode_url',      vscode_urlEdit)
        self.registerField('arm_url',         arm_urlEdit)
        self.registerField('gcm_url',         gcm_urlEdit)

        if os_name == "Darwin":
            vscode_urlEdit.setText("https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal")
            arm_urlEdit.setText("https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2")
            gcm_urlEdit.setText("curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh")
        elif os_name == "Windows":
            vscode_urlEdit.setText("https://update.code.visualstudio.com/latest/win32-x64-archive/stable")
            arm_urlEdit.setText("https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip")
            gcm_urlEdit.setText("https://github.com/git-for-windows/git/releases/download/v2.37.3.windows.1/Git-2.37.3-64-bit.exe")
        elif os_name == "Linux":
            vscode_urlEdit.setText("https://update.code.visualstudio.com/latest/linux-x64/stable")
            arm_urlEdit.setText("https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2")
            gcm_urlEdit.setText("https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.785/gcm-linux_amd64.2.0.785.deb")

        urlBoxL = QtWidgets.QVBoxLayout()
        urlBoxL.addWidget(vscode_urlDescription)
        urlBoxL.addWidget(vscode_urlEdit)
        urlBoxL.addWidget(arm_urlDescription)
        urlBoxL.addWidget(arm_urlEdit)
        urlBoxL.addWidget(gcm_urlDescription)
        urlBoxL.addWidget(gcm_urlEdit)
        urlBox.setLayout(urlBoxL)

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(checkBox)
        layout.addWidget(urlBox)
        
        self.setLayout(layout)
                           
class ProceedPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(ProceedPage, self).__init__(parent)

        self.setTitle("Proceed ?")        

        label = QtWidgets.QLabel("The wizard is ready to install the IDE.\n"
                "Click on *next* to install\n"
                "Click on *cancel* to abort")
        label.setWordWrap(True)

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(label)
        self.setLayout(layout)
    

class InstallPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(InstallPage, self).__init__(parent)

        self.setTitle("Installation in progress") 

        label = QtWidgets.QLabel("The wizard is installing the IDE.\n"
                "Please be patient (it could take a few of minutes depending on your connection)")
        label.setWordWrap(True)
        progress = QtWidgets.QProgressBar()

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(label)
        layout.addWidget(progress)
        self.setLayout(layout)

    def initializePage(self):
        logging.warning("Settings summary: ")
        for f in fields:
            logging.info(f + ": " + str(self.field(f)))

    def isComplete(self):
        return False
    
if __name__ == '__main__':
    import sys

    log_file = "install-" + time.strftime("%Y-%m-%d-%H-%M-%S") + ".log"
    logging.basicConfig(filename=log_file, encoding='utf-8', level=logging.INFO)
    logging.warning("Log saved at: " + log_file)
    
    app = QtWidgets.QApplication(sys.argv)
    wizard = ClassWizard()
    wizard.show()
    sys.exit(app.exec_())