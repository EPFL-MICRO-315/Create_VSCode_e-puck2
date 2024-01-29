from PyQt5 import QtCore, QtGui, QtWidgets

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
        className = self.field('className')

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
        installPathLabel = QtWidgets.QLabel(installPath)
        def installPath_dialog():
            nonlocal installPath
            tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", installPath)
            if tmp != "":
                installPath = tmp
            installPathLabel.setText(installPath)

        workplacePath = str(QtCore.QDir.homePath() + "/Documents/")
        workplacePathLabel = QtWidgets.QLabel(workplacePath)
        def workplacePath_dialog():
            nonlocal workplacePath
            tmp = QtWidgets.QFileDialog.getExistingDirectory(None, "Select Directory", workplacePath)
            if tmp != "":
                workplacePath = tmp
            workplacePathLabel.setText(workplacePath)


        self.setTitle("Custom the setup")     
        self.setSubTitle("Specify in more details where you want the wizard to setup the IDE")


        installPathBox = QtWidgets.QGroupBox("Install Path:")
        installPathButton = QtWidgets.QPushButton('...')
        installPathButton.clicked.connect(installPath_dialog)
        installPathDescription = QtWidgets.QLabel("Where the IDE and its components will be stored")
        
        installPathBoxL = QtWidgets.QGridLayout()
        installPathBoxL.addWidget(installPathDescription, 0, 0, 1, 2)
        installPathBoxL.addWidget(installPathLabel)
        installPathBoxL.addWidget(installPathButton)        
        installPathBox.setLayout(installPathBoxL);
        
        workplacePathBox = QtWidgets.QGroupBox("Workplace Path:")
        workplacePathButton = QtWidgets.QPushButton('...')
        workplacePathButton.clicked.connect(workplacePath_dialog)
        workplacePathDescription = QtWidgets.QLabel("Where the librairies, exercises and your project will be stored")
        
        workplacePathBoxL = QtWidgets.QGridLayout()
        workplacePathBoxL.addWidget(workplacePathDescription, 0, 0, 1, 2)
        workplacePathBoxL.addWidget(workplacePathLabel, 1, 0)
        workplacePathBoxL.addWidget(workplacePathButton, 1, 1)       
        workplacePathBox.setLayout(workplacePathBoxL);

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(installPathBox)
        layout.addWidget(workplacePathBox)
        self.setLayout(layout)

        # registerField functions are used to let other pages accessing the specfied variable with user defined key
        self.registerField("install_path", installPathLabel)
        self.registerField("workplace_path", workplacePathLabel)

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
        gcm_urlDescription = QtWidgets.QLabel("GCM (Github Credential Manager) download URL:")
        gcm_urlEdit = QtWidgets.QLineEdit()
        
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

        self.registerField("vscode",          vscode)
        self.registerField("vscode_settings", vscode_settings)
        self.registerField("arm",             arm)
        self.registerField("gcm",             gcm)
        self.registerField("workplace",       workplace)
        self.registerField("shortcut",        shortcut)
        self.registerField("clear_cache",     clear_cache)
        self.registerField("vscode_url",      vscode_urlEdit)
        self.registerField("arm_url",         arm_urlEdit)
        self.registerField("gcm_url",         gcm_urlEdit)

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

        layout = QtWidgets.QVBoxLayout()
        layout.addWidget(label)
        self.setLayout(layout)

if __name__ == '__main__':
    import sys

    app = QtWidgets.QApplication(sys.argv)
    wizard = ClassWizard()
    wizard.show()
    sys.exit(app.exec_())