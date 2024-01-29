from PyQt5 import QtCore, QtGui, QtWidgets

class ClassWizard(QtWidgets.QWizard):
    def __init__(self, parent=None):
        super(ClassWizard, self).__init__(parent)

        self.addPage(IntroPage())

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
        #self.setSubTitle("Specify where you want the wizard to put the "
        #        "generated skeleton code.")
        

        label = QtWidgets.QLabel("This wizard will install on this computer a copy of VSCode EPuck 2 IDE.\n"
                "This software includes the editor (VSCode) with pre-installed extensions, "
                "it also includes the ARM toolchain (compiler and debugger).")
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