import os

from ignis import utils
from ignis.command_manager import CommandManager
from ignis.css_manager import CssInfoPath, CssManager

from modules.bar import Bar
from modules.launcher import Launcher

css = CssManager.get_default()
css.apply_css(
    CssInfoPath(
        name="main",
        path=os.path.expanduser("~/.config/ignis/hypr/style.scss"),
        compiler_function=lambda path: utils.sass_compile(path=path),
        priority = "user"
    )
)

for i in range(utils.get_n_monitors()):  # pyright: ignore[reportAttributeAccessIssue]
    Bar(i)


commands = CommandManager.get_default()
commands.add_command("open-launcher", lambda: Launcher() and "ok" or "error")
