from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtCore import QObject, QThread, pyqtSignal
import logging
import time
import platform
import installer
import uninstaller
from utils import *
import sys

os_name = platform.system()
fields = [ 'install_path', 'workplace_path', 'vscode', 'vscode_settings', 'arm', 'monitor', 'tools', 'gcm', 'workplace', 'shortcut', 'clear_cache', 'vscode_url', 'arm_url', 'gcm_url', 'monitor_url' ]
fields_steps = [ 'vscode', 'vscode_settings', 'arm', 'monitor', 'tools', 'gcm', 'workplace', 'shortcut' ]
intro_id = 0
setup_id = 1
advanced_setup_id = 2
proceed_id = 3
install_id = 4

class ClassWizard(QtWidgets.QWizard):
    def __init__(self, parent=None):
        super(ClassWizard, self).__init__(parent)
        
        self.setPage(intro_id, IntroPage())
        self.setPage(setup_id, SetupPage())
        self.setPage(advanced_setup_id, AdvancedSetupPage())
        self.setPage(proceed_id, ProceedPage())
        self.setPage(install_id, InstallPage())
        
        self.setWindowTitle("VSCode EPuck2 Setup")
        self.setMinimumSize(800, 550)
                                                                                                                             
        px = QtGui.QPixmap('Universal/e-puck2.png')
        px = px.scaled(250, 250, QtCore.Qt.KeepAspectRatio)
        self.setPixmap(QtWidgets.QWizard.WatermarkPixmap, px)
        self.setWizardStyle(QtWidgets.QWizard.ModernStyle)
        
    def accept(self):
        super(ClassWizard, self).accept()


class IntroPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(IntroPage, self).__init__(parent)

        self.setTitle("Welcome to the VSCode EPuck2 Setup Wizard")        

        label = QtWidgets.QLabel("This wizard is able to install and uninstall on this computer a copy of VSCode EPuck 2 IDE.\n"
                "This software includes the editor (VSCode) with pre-installed extensions, "
                "it also includes the ARM toolchain (compiler and debugger).")
        label.setWordWrap(True)

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(label)
        self.setLayout(layout)

class SetupPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(SetupPage, self).__init__(parent)

    def initializePage(self):
        if sys.argv[1] == "install":
            if os_name == "Darwin":
                installPath = os.popen("echo $HOME/Applications/").read().rstrip()
                workplacePath = os.popen("echo $HOME/Documents/").read().rstrip()
            elif os_name == "Windows":
                installPath = os.popen("echo %APPDATA%").read().rstrip()
                workplacePath = os.popen("echo %USERPROFILE%\\Documents\\").read().rstrip()
            elif os_name == "Linux":
                installPath = os.popen("echo $HOME/.local/bin/").read().rstrip()
                workplacePath = os.popen("echo $HOME/Documents/").read().rstrip()
            
            installPathWarning = QtWidgets.QLabel("")
            installPathWarning.setStyleSheet("QLabel { color : red; }")
            installPathEdit = QtWidgets.QLineEdit(installPath)
            def checkForSpaceInstallPath():
                if (' ' in installPathEdit.text()) or (not installPathEdit.text().isascii()):
                    installPathWarning.setText("Warning!: path containing space, choose another path")
                else:
                    installPathWarning.setText("")
                self.completeChanged.emit()

            installPathEdit.textChanged.connect(checkForSpaceInstallPath)
            def installPath_dialog():
                nonlocal installPath
                installPath = installPathEdit.text()
                tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", installPath)
                if tmp != "":
                    installPath = tmp
                checkForSpaceInstallPath()
                installPathEdit.setText(installPath)

            workplacePathWarning = QtWidgets.QLabel("")
            workplacePathWarning.setStyleSheet("QLabel { color : red; }")
            workplacePathEdit = QtWidgets.QLineEdit(workplacePath)
            def checkForSpaceWorkplacePath():
                if (' ' in workplacePathEdit.text()) or (not workplacePathEdit.text().isascii()):
                    workplacePathWarning.setText("Warning!: path containing space or punctuation, choose another path")
                else:
                    workplacePathWarning.setText("")
                self.completeChanged.emit()

            workplacePathEdit.textChanged.connect(checkForSpaceWorkplacePath)
            def workplacePath_dialog():
                nonlocal workplacePath
                workplacePath = workplacePathEdit.text()
                tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", workplacePath)
                if tmp != "":
                    workplacePath = tmp
                checkForSpaceWorkplacePath()
                workplacePathEdit.setText(workplacePath)

            installPathBox = QtWidgets.QGroupBox("IDE (VSCode, tools, ...) Path:")
            installPathButton = QtWidgets.QPushButton('...')
            installPathButton.clicked.connect(installPath_dialog)
            installPathDescription = QtWidgets.QLabel("Where the IDE and its components will be stored")
            
            installPathBoxL = QtWidgets.QGridLayout()
            installPathBoxL.addWidget(installPathDescription, 0, 0, 1, 2)
            installPathBoxL.addWidget(installPathEdit)
            installPathBoxL.addWidget(installPathButton)
            installPathBoxL.addWidget(installPathWarning, 2, 0, 1, 2)        
            installPathBox.setLayout(installPathBoxL);
            
            workplacePathBox = QtWidgets.QGroupBox("Workplace Path:")
            workplacePathButton = QtWidgets.QPushButton('...')
            workplacePathButton.clicked.connect(workplacePath_dialog)
            workplacePathDescription = QtWidgets.QLabel("Where the librairies, exercises and your project will be stored")
            
            workplacePathBoxL = QtWidgets.QGridLayout()
            workplacePathBoxL.addWidget(workplacePathDescription, 0, 0, 1, 2)
            workplacePathBoxL.addWidget(workplacePathEdit, 1, 0)
            workplacePathBoxL.addWidget(workplacePathButton, 1, 1)    
            workplacePathBoxL.addWidget(workplacePathWarning, 2, 0, 1, 2)   
            workplacePathBox.setLayout(workplacePathBoxL);

            # registerField functions are used to let other pages accessing the specfied variable with user defined key
            self.registerField('install_path', installPathEdit)
            self.registerField('workplace_path', workplacePathEdit)
            
            self.setTitle("Custom the setup - Install")     
            self.setSubTitle("Specify in more details where you want the wizard to install the IDE")

            layout = QtWidgets.QVBoxLayout()
            layout.addWidget(installPathBox)
            layout.addWidget(workplacePathBox)
            self.setLayout(layout)
            
        else:
            if os_name == "Darwin":
                installPath = os.popen("echo $HOME/Applications/").read().rstrip()
            elif os_name == "Windows":
                installPath = os.popen("echo %APPDATA%").read().rstrip()
            elif os_name == "Linux":
                installPath = os.popen("echo $HOME/.local/bin/").read().rstrip()
            
            installPathWarning = QtWidgets.QLabel("")
            installPathWarning.setStyleSheet("QLabel { color : red; }")
            installPathEdit = QtWidgets.QLineEdit(installPath)
            def checkForSpaceInstallPath():
                if (' ' in installPathEdit.text()) or (not installPathEdit.text().isascii()):
                    installPathWarning.setText("Warning!: path containing space, choose another path")
                else:
                    installPathWarning.setText("")
                self.completeChanged.emit()
            
            installPathEdit.textChanged.connect(checkForSpaceInstallPath)
            def installPath_dialog():
                nonlocal installPath
                installPath = installPathEdit.text()
                tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", installPath)
                if tmp != "":
                    installPath = tmp
                checkForSpaceInstallPath()
                installPathEdit.setText(installPath)

            installPathBox = QtWidgets.QGroupBox("IDE (VSCode, tools, ...) Path:")
            installPathButton = QtWidgets.QPushButton('...')
            installPathButton.clicked.connect(installPath_dialog)
            installPathDescription = QtWidgets.QLabel("Where the IDE and its components were previously installed")
            
            installPathBoxL = QtWidgets.QGridLayout()
            installPathBoxL.addWidget(installPathDescription, 0, 0, 1, 2)
            installPathBoxL.addWidget(installPathEdit)
            installPathBoxL.addWidget(installPathButton)
            installPathBoxL.addWidget(installPathWarning, 2, 0, 1, 2)      
            installPathBox.setLayout(installPathBoxL);

            self.validateLabel = QtWidgets.QLabel("")

            # registerField functions are used to let other pages accessing the specfied variable with user defined key
            self.registerField('install_path', installPathEdit)
            
            self.setTitle("Custom the setup - Uninstall")     
            self.setSubTitle("Specify in more details where is located the IDE to be uninstalled")

            layout = QtWidgets.QVBoxLayout()
            layout.addWidget(installPathBox)
            layout.addWidget(self.validateLabel)
            self.setLayout(layout)

    def isComplete(self):
        if sys.argv[1] == "install":
            if (' ' in self.field('install_path')) or (' ' in self.field('workplace_path')) or \
               (not self.field('install_path').isascii()) or (not self.field('workplace_path').isascii()):
                return False
            return True
        else:
            if os_name == "Darwin":
                folder = self.field('install_path') + "/EPuck2_VSCode.app"
            else:
                folder = self.field('install_path') + "/EPuck2_VSCode"
            if os.path.isdir(folder):
                self.validateLabel.setText("")
                return True
            self.validateLabel.setText("The specified path does not contain the IDE")
            logging.error("The specified path does not contain the IDE")
            return False
    
    def nextId(self):
        if sys.argv[1] == "install":
            return advanced_setup_id
        else:
            return proceed_id

class AdvancedSetupPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(AdvancedSetupPage, self).__init__(parent)

        self.setTitle("Custom the setup (Advanced)")     
        self.setSubTitle("Specify in more details what component you want the wizard to setup\n"
                         "Do not modify unless you know what you are doing!")
        
        checkBox1 = QtWidgets.QGroupBox("Components selection")
        vscode          = QtWidgets.QCheckBox("(re)install VSCode ?")
        vscode_settings = QtWidgets.QCheckBox("(re) VSCode settings?")
        arm             = QtWidgets.QCheckBox("(re)install ARM toolchain ?")
        monitor         = QtWidgets.QCheckBox("(re)install EPuck2 monitor ?")
        tools           = QtWidgets.QCheckBox("(re)install required tools (git, dfu-utils, various gnu tools) ?")
        gcm             = QtWidgets.QCheckBox("(re)install GCM (Github Credential Manager) ?")
        workplace       = QtWidgets.QCheckBox("(re)install workplace ?")
        shortcut        = QtWidgets.QCheckBox("(re)create shortcut ?")

        vscode.setChecked(True)
        vscode_settings.setChecked(True)
        arm.setChecked(True)
        monitor.setChecked(True)
        tools.setChecked(True)
        gcm.setChecked(True)
        workplace.setChecked(True)
        shortcut.setChecked(True)

        checkBoxL1 = QtWidgets.QVBoxLayout()
        checkBoxL1.addWidget(tools)
        checkBoxL1.addWidget(gcm)
        checkBoxL1.addWidget(vscode)
        checkBoxL1.addWidget(arm)
        checkBoxL1.addWidget(monitor)
        checkBoxL1.addWidget(vscode_settings)
        checkBoxL1.addWidget(workplace)
        checkBoxL1.addWidget(shortcut)
        checkBox1.setLayout(checkBoxL1);
    
        checkBox2 = QtWidgets.QGroupBox("Clear cache after installation ?")
        clear_cache     = QtWidgets.QCheckBox("Clears any unnecessary intermediate traces after installation")
        clear_cache.setChecked(False)

        checkBoxL2 = QtWidgets.QVBoxLayout()
        checkBoxL2.addWidget(clear_cache) 
        checkBox2.setLayout(checkBoxL2);

        urlBox = QtWidgets.QGroupBox("Download URLs")
        vscode_urlDescription = QtWidgets.QLabel("VSCode download URL:")
        vscode_urlEdit = QtWidgets.QLineEdit()
        arm_urlDescription = QtWidgets.QLabel("ARM Toolchain download URL:")
        arm_urlEdit = QtWidgets.QLineEdit()
        gcm_urlDescription = QtWidgets.QLabel("GCM (Github Credential Manager) download command:")
        gcm_urlEdit = QtWidgets.QLineEdit()
        monitor_urlDescription = QtWidgets.QLabel("EPuck 2 monitor download URL:")
        monitor_urlEdit = QtWidgets.QLineEdit()
        
        self.registerField('vscode',          vscode)
        self.registerField('vscode_settings', vscode_settings)
        self.registerField('arm',             arm)
        self.registerField('monitor',         monitor)
        self.registerField('tools',           tools)
        self.registerField('gcm',             gcm)
        self.registerField('workplace',       workplace)
        self.registerField('shortcut',        shortcut)
        self.registerField('clear_cache',     clear_cache)
        self.registerField('vscode_url',      vscode_urlEdit)
        self.registerField('arm_url',         arm_urlEdit)
        self.registerField('monitor_url',     monitor_urlEdit)

        if os_name == "Darwin":
            vscode_urlEdit.setText("https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal")
            arm_urlEdit.setText("https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-mac.tar.bz2")
            gcm_urlEdit.setText("")
            monitor_urlEdit.setText("https://projects.gctronic.com/epuck2/monitor_mac.zip")
        elif os_name == "Windows":
            vscode_urlEdit.setText("https://update.code.visualstudio.com/latest/win32-x64-archive/stable")
            arm_urlEdit.setText("https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-win32.zip")
            gcm_urlEdit.setText("https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe")
            monitor_urlEdit.setText("https://projects.gctronic.com/epuck2/monitor_win.zip")
        elif os_name == "Linux":
            vscode_urlEdit.setText("https://update.code.visualstudio.com/latest/linux-x64/stable")
            arm_urlEdit.setText("https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2")
            gcm_urlEdit.setText("https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb")
            monitor_urlEdit.setText("https://projects.gctronic.com/epuck2/monitor_linux64bit.tar.gz")

        urlBoxL = QtWidgets.QVBoxLayout()
        urlBoxL.addWidget(vscode_urlDescription)
        urlBoxL.addWidget(vscode_urlEdit)
        urlBoxL.addWidget(arm_urlDescription)
        urlBoxL.addWidget(arm_urlEdit)
        urlBoxL.addWidget(monitor_urlDescription)
        urlBoxL.addWidget(monitor_urlEdit)
        if os_name != "Darwin":
            self.registerField('gcm_url',         gcm_urlEdit)
            urlBoxL.addWidget(gcm_urlDescription)
            urlBoxL.addWidget(gcm_urlEdit)
        urlBox.setLayout(urlBoxL)

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(checkBox1)
        layout.addWidget(checkBox2)
        layout.addWidget(urlBox)
        
        self.setLayout(layout)
                           
class ProceedPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(ProceedPage, self).__init__(parent)

        self.setTitle("Proceed ?")        

        label = QtWidgets.QLabel("The wizard is ready to proceed")
                
        label.setWordWrap(True)

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(label)
        self.setLayout(layout)
        self.setCommitPage(True)

        if sys.argv[1] == "install":
            self.setButtonText(QtWidgets.QWizard.CommitButton, "Install")
        else:
            self.setButtonText(QtWidgets.QWizard.CommitButton, "Uninstall")
class InstallPage(QtWidgets.QWizardPage):
    def __init__(self, parent=None):
        super(InstallPage, self).__init__(parent)
        self.isCompleteValue = False
        self.setTitle("Installation in progress") 

        self.label = QtWidgets.QLabel("The wizard is installing the IDE.\n"
                                      "Please be patient (it could take a few of minutes depending on your connection)\n\n"
                                      "Check the terminal as it might ask for user password to gain more privileges during intallation!")
        self.label.setWordWrap(True)
        
        self.progress = QtWidgets.QProgressBar()
        
        self.console = QtWidgets.QTextEdit()
        self.console.setReadOnly(True)
        qt_handler.signal.connect(self.updateConsole)
        
        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(self.label)
        layout.addWidget(self.progress)
        layout.addWidget(self.console)
        self.setLayout(layout)

    def initializePage(self):
        logging.warning("Settings summary: ")
        for f in fields:
            installer.settings[f] = self.field(f)
            uninstaller.settings[f] = self.field(f)
            logging.info(f + ": " + str(installer.settings[f]))
        logging.warning("Installation starting")

        
        self.thread = QThread()

        if sys.argv[1] == "install":
            self.worker = Installer()
            self.progress.setRange(0, sum(installer.settings[k] for k in fields_steps))
        else:
            self.worker = Uninstaller()
            self.progress.setRange(0, 4)
        
        self.worker.moveToThread(self.thread)
        self.thread.started.connect(self.worker.run)
        self.worker.finished.connect(self.thread.quit)
        self.thread.finished.connect(self.installerComplete)
        self.worker.progress.connect(self.increaseProgress)
        self.thread.start()

    def updateConsole(self, text):            
        # Parse the log level from the text
        log_level, log_content = text.split(":")[0], ":".join(text.split(":")[2:])

        # Set the text color based on the log level
        weight = "bold"
        if os_name == "Darwin":
            if log_level == "CRITICAL":
                color = "red"
            elif log_level == "ERROR":
                color = "darkred"
            elif log_level == "WARNING":
                color = "yellow"
            elif log_level == "PROGRESS":
                color = "steelblue"
            else:
                text = log_content
                color = "white"
                weight = "normal"
        else:
            if log_level == "CRITICAL":
                color = "red"
            elif log_level == "ERROR":
                color = "darkred"
            elif log_level == "WARNING":
                color = "darkorange"
            elif log_level == "PROGRESS":
                color = "darkblue"
            else:
                text = log_content
                color = "black"
                weight = "normal"
        html = '<div style="font-weight: {}; color: {}">{}</div>'.format(weight, color, text+"\n")

        self.console.append(html)

    def increaseProgress(self):
        self.progress.setValue(self.progress.value() + 1)
        logging.progress(str(self.progress.value()) + "/" + str(self.progress.maximum()))

    def installerComplete(self):
        self.increaseProgress()
        try:
            self.worker.deleteLater()
        except:
            pass

        self.setTitle("Installation completed") 
        self.isCompleteValue = True
        self.completeChanged.emit()
        
    def isComplete(self):
        return self.isCompleteValue
    
class Installer(QObject):
    finished = pyqtSignal()
    progress = pyqtSignal()

    def run(self):
        installer.init_folders()        
        if(installer.settings["tools"]):
            self.progress.emit()
            installer.step0()
        if(installer.settings["gcm"]):        
            self.progress.emit()
            installer.step1()
        if(installer.settings["vscode"]):
            self.progress.emit()
            installer.step2()
        if(installer.settings["arm"]):
            self.progress.emit()
            installer.step3()
        if(installer.settings["monitor"]):
            self.progress.emit()
            installer.step4()
        if(installer.settings["vscode_settings"]):
            self.progress.emit()
            installer.step5()
        if(installer.settings["workplace"]):
            self.progress.emit()
            installer.step6()
        if(installer.settings["shortcut"]):
            self.progress.emit()
            installer.step7()
        self.finished.emit()

class Uninstaller(QObject):
    finished = pyqtSignal()
    progress = pyqtSignal()

    def run(self):    
        self.progress.emit()
        uninstaller.step1()
        self.progress.emit()
        uninstaller.step2()
        self.progress.emit()
        uninstaller.step3()
        self.progress.emit()
        uninstaller.step4()
        self.finished.emit()
        
class QtHandler(logging.Handler, QObject):
    signal = pyqtSignal(str)

    def __init__(self):
        logging.Handler.__init__(self)
        QObject.__init__(self)

    def emit(self, record):
        record = self.format(record)
        self.signal.emit(record)

if __name__ == '__main__':
    if(len(sys.argv) == 1):
        print("error: no argument provided (install or uninstall)")
        sys.exit()
    if((sys.argv[1] != "install") and (sys.argv[1] != "uninstall")):
        print("error: invalid argument provided (install or uninstall)")
        sys.exit()

    log_file = "install-" + time.strftime("%Y-%m-%d-%H-%M-%S") + ".log"

    file_handler = logging.FileHandler(filename=log_file)
    stdout_handler = logging.StreamHandler(stream=sys.stdout)
    qt_handler = QtHandler()
    handlers = [file_handler, stdout_handler, qt_handler]
    
    logging.basicConfig(encoding='utf-8', level=logging.INFO, handlers=handlers)
    addLoggingLevel("PROGRESS", 25)
    logging.warning("Log saved at: " + log_file)
    
    app = QtWidgets.QApplication(sys.argv)
    wizard = ClassWizard()
    wizard.show()
    sys.exit(app.exec_())