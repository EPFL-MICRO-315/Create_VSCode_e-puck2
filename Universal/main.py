from PyQt5.QtWidgets import QApplication, QLabel

import logging
import installer
import random
from utils import *

install = False

# Create the Qt5 application boilerplate code

log_file = "install.log" + time.strftime("%Y-%m-%d-%H-%M-%S") + ".log"
logging.basicConfig(filename=log_file, encoding='utf-8', level=logging.INFO)
logging.error("Log saved at: " + log_file)

if install:
    logging.debug("Installation starting")
    logging.info("Settings: " + str(installer.settings.dict))
    installer.init_folders()
    installer.step1()
    installer.step2()
    installer.step3()
    installer.step4()
    installer.step5()
    installer.step6()
    logging.debug("Installation complete")
else:
    logging.debug("Installation cancelled")
