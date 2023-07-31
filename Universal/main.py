from kivy.app import App
from kivy.uix.settings import SettingsWithTabbedPanel
#from kivy.uix.button import Button
from kivy.uix.label import Label
#from kivy.uix.boxlayout import BoxLayout
#from kivy.uix.progressbar import ProgressBar
#from kivy.uix.scrollview import ScrollView
from kivy.logger import Logger
from kivy.lang import Builder
from kivy.config import Config

Config.set('input', 'mouse', 'mouse,multitouch_on_demand')
Config.set('kivy', 'exit_on_escape', '0')
import logging
import installer
from utils import *

console = "\n"

kv = '''
BoxLayout:
    orientation: 'vertical'
    id: pages
    BoxLayout:
        orientation: 'horizontal'
        BoxLayout:
            id: page1
            canvas:
                Color:
                    rgb: 0, 0, 0, 1
                Rectangle:
                    pos: self.pos
                    size: self.size
            orientation: 'vertical'
            Button:
                text: 'Install VSCode EPuck2'
                on_release: app.install()
            Button:
                text: 'Uninstall VSCode EPuck2'
                on_release: app.uninstall()
            Button:
                text: 'Settings (or press F1)'
                on_release: app.open_settings()
        BoxLayout:
            id: page2
            disabled: True
            canvas:
                Color:
                    rgb: 0, 0, 0, 1
                Rectangle:
                    pos: self.pos
                    size: self.size
            orientation: 'vertical'
            ScrollView:
                Label:
                    id: console
                    size_hint: 1, None
                    size: self.texture_size
            ProgressBar:
                id: progressbar
                size_hint: 1, 0.1
                opacity: 0
                max: 1000
                value: 0
    Button
        size_hint: 1, 0.2
        text: 'Exit'
        on_release: app.stop()
'''

settings_json = '''
[
    {
        "type": "path",
        "title": "Install path",
        "desc": "Choose where to install VSCode EPuck2 and its tools",
        "section": "settings",
        "key": "install_path"
    },
    {
        "type": "path",
        "title": "Workplace path",
        "desc": "Choose where to store the libraries and your projects",
        "section": "settings",
        "key": "workplace_path"
    },
    {
        "type": "bool",
        "title": "(re)install git",
        "desc": "If checked, git will be re-installed",
        "section": "settings",
        "key": "gcm"
    },
    {
        "type": "bool",
        "title": "(re)install arm-gcc toolchain",
        "desc": "If checked, arm-gcc toolchain will be re-installed",
        "section": "settings",
        "key": "arm_gcc_toolchain"
    },
    {
        "type": "bool",
        "title": "(re)install VSCode",
        "desc": "If checked, Visual Studio Code will be re-installed",
        "section": "settings",
        "key": "vscode_app"
    },
    {
        "type": "bool",
        "title": "(re)configure VSCode",
        "desc": "If checked, computer's specific settings will be overwritten",
        "section": "settings",
        "key": "vscode_settings"
    },
    {
        "type": "bool",
        "title": "(re)install workplace",
        "desc": "If checked,the workplace will be overwritten",
        "section": "settings",
        "key": "workplace_reinstall"
    },
    {
        "type": "bool",
        "title": "(re)create shortcut",
        "desc": "If checked, VSCode EPuck2's shortcut will be re-created",
        "section": "settings",
        "key": "shortcut"
    },
    {
        "type": "string",
        "title": "VSCode download url",
        "desc": "Specific to host's operating system",
        "section": "settings",
        "key": "vscode_url"
    },
    {
        "type": "string",
        "title": "arm_gcc_toolchain download url",
        "desc": "Specific to host's operating system",
        "section": "settings",
        "key": "arm_gcc_toolchain_url"
    },
    {
        "type": "bool",
        "title": "clear cache",
        "desc": "Delete all temporary files created during installation",
        "section": "settings",
        "key": "clear_cache"
    }
]
'''

class MyApp(App):
    use_kivy_settings = False # otherwise polluted by useless GUI settings

    def build(self):
        root = Builder.load_string(kv)
        root.ids.console.text = console
        return root

    def build_config(self, config):
        config.setdefaults('settings', installer.settings.dict)

    def build_settings(self, settings):
        settings.add_json_panel('VSCode EPuck2 settings', self.config, data=settings_json)

    def on_config_change(self, config, section, key, value):
        Logger.info("main.py: App.on_config_change: {0}, {1}, {2}, {3}".format(
            config, section, key, value))
        installer.settings.dict[key] = value

    def close_settings(self, settings=None):
        Logger.info("main.py: App.close_settings: {0}".format(settings))
        super(MyApp, self).close_settings(settings)

    def console_push_back(self, text):
        global console
        console = console + text
        self.root.ids.console.text = console

    def install(self):
        self.root.ids.page1.disabled = True
        self.root.ids.page2.disabled = False
        self.root.ids.progressbar.opacity = 1
        for key in installer.settings.dict:
            print(key, self.config.get('settings', key)) 
            installer.settings.dict[key] = self.config.get('settings', key)
        print(installer.settings)
        installer.init_folders()
        installer.step1()
        installer.step2()
        installer.step3()
        installer.step4()
        installer.step5()
        installer.step6()
        
    def uninstall(self):
        Logger.info("Uninstall")
        self.root.ids.page1.disabled = True
        self.root.ids.page2.disabled = False
        self.root.ids.progressbar.opacity = 1

MyApp().run()
