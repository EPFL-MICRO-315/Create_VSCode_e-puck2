from kivy.app import App
from kivy.uix.settings import SettingsWithTabbedPanel
from kivy.logger import Logger, ColoredFormatter
from kivy.lang import Builder
from kivy.config import Config
Config.set('kivy', 'exit_on_escape', '0')
import logging
# We first define our GUI
kv = '''
AnchorLayout:
    AnchorLayout:
        anchor_x: 'center'
        anchor_y: 'center'
        size_hint: 0.75, 0.4
        pos_hint: {'center_x': 0.5, 'center_y': 0.5}

        BoxLayout:
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
            Button:
                text: 'Exit'
                on_release: app.stop()
'''

# This JSON defines entries we want to appear in our App configuration screen
json = '''
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
        "title": "Workspace path",
        "desc": "Choose where to store the libraries and your projects",
        "section": "settings",
        "key": "workspace_path"
    },
    {
        "type": "bool",
        "title": "(re)install git",
        "desc": "If checked, git will be re-installed",
        "section": "settings",
        "key": "git"
    },
    {
        "type": "bool",
        "title": "(re)install arm-gcc toolchain",
        "desc": "If checked, arm-gcc toolchain will be re-installed",
        "section": "settings",
        "key": "arm"
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
        "title": "(re)install VSCode's extensions",
        "desc": "If checked, Visual Studio's extensions (cortex, git history, ...) will be re-installed",
        "section": "settings",
        "key": "vscode_extensions"
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
        "title": "(re)install workspace",
        "desc": "If checked,the workspace will be overwritten",
        "section": "settings",
        "key": "workspace"
    },
    {
        "type": "bool",
        "title": "(re)create shortcut",
        "desc": "If checked, VSCode EPuck2's shortcut will be re-created",
        "section": "settings",
        "key": "shortcut"
    }
]
'''


class MyApp(App):
    use_kivy_settings = False # otherwise polluted by useless GUI settings

    def build(self):
        """
        Build and return the root widget.
        """
        # The line below is optional. You could leave it out or use one of the
        # standard options, such as SettingsWithSidebar, SettingsWithSpinner
        # etc.
        #self.settings_cls = MySettingsWithTabbedPanel

        # We apply the saved configuration settings or the defaults
        root = Builder.load_string(kv)
        #label = root.ids.label
        #label.text = self.config.get('My Label', 'text')
        #label.font_size = float(self.config.get('My Label', 'font_size'))
        return root

    def build_config(self, config):
        """
        Set the default values for the configs sections.
        """
        config.setdefaults('settings', {
            'install_path': '/',
            'workspace_path': '/',
            'git': 1,
            'arm': 1,
            'vscode_app': 1,
            'vscode_extensions': 1,
            'vscode_settings': 1,
            'workspace': 1,
            'shortcut': 1
        })

    def build_settings(self, settings):
        """
        Add our custom section to the default configuration object.
        """
        settings.add_json_panel('VSCode EPuck2 settings', self.config, data=json)


    def on_config_change(self, config, section, key, value):
        """
        Respond to changes in the configuration.
        """
        #Logger.info("main.py: App.on_config_change: {0}, {1}, {2}, {3}".format(
        #    config, section, key, value))

        #if section == "My Label":
        #    if key == "text":
        #        self.root.ids.label.text = value
        #    elif key == 'font_size':
        #        self.root.ids.label.font_size = float(value)

    def close_settings(self, settings=None):
        """
        The settings panel has been closed.
        """
        Logger.info("main.py: App.close_settings: {0}".format(settings))
        super(MyApp, self).close_settings(settings)

    def install(self):
        Logger.info("Install")

    def uninstall(self):
        Logger.info("Uninstall")

class MySettingsWithTabbedPanel(SettingsWithTabbedPanel):
    """
    It is not usually necessary to create subclass of a settings panel. There
    are many built-in types that you can use out of the box
    (SettingsWithSidebar, SettingsWithSpinner etc.).

    You would only want to create a Settings subclass like this if you want to
    change the behavior or appearance of an existing Settings class.
    """
    def on_close(self):
        Logger.info("main.py: MySettingsWithTabbedPanel.on_close")

    #def on_config_change(self, config, section, key, value):
    #    Logger.info(
    #        "main.py: MySettingsWithTabbedPanel.on_config_change: "
    #        "{0}, {1}, {2}, {3}".format(config, section, key, value))

logging.Formatter.default_msec_format = '%s.%01d'
# Add timestamp to log file
Logger.handlers[1].setFormatter(logging.Formatter('%(asctime)s %(message)s'))
# Add timestampt to console output
Logger.handlers[2].setFormatter(ColoredFormatter('[%(levelname)-18s] %(asctime)s %(message)s'))
MyApp().run()
