from ignis import widgets

from widgets.network import NetworkUsageWidget, VpnStatusWidget
from widgets.separator import Separator
from widgets.sys_tray import SystemTray
from widgets.system import CpuTemperatureWidget, CpuUsageWidget, MemoryUsageWidget
from widgets.time import DateTimeWidget, TimeWidget
from widgets.workspaces import HyprlandWorkspaces


def Bar(monitor: int) -> widgets.Window:
    return widgets.Window(
        monitor=monitor,
        namespace=f"shell-bar-{monitor}",
        exclusivity="exclusive",
        layer="bottom",
        anchor=["left", "top", "right"],
        child=widgets.CenterBox(
            css_classes=["bar"],
            start_widget=widgets.Box(
                css_classes=["bar_left_modules"],
                spacing=8,
                child=[
                    NetworkUsageWidget(upload=False),
                    Separator(),
                    NetworkUsageWidget(upload=True),
                    Separator(),
                    VpnStatusWidget(),
                ],
            ),
            center_widget=widgets.CenterBox(
                css_classes=["bar_center_modules"],
                hexpand=False,
                halign="center",
                start_widget=widgets.Box(
                    hexpand=True,
                    halign="end",
                    spacing=2,
                    child=[TimeWidget(), Separator()],
                ),
                center_widget=HyprlandWorkspaces(),
                end_widget=widgets.Box(
                    hexpand=True,
                    halign="start",
                    spacing=2,
                    child=[Separator(), DateTimeWidget("%d %B %Y", 1000)],
                ),
            ),
            end_widget=widgets.Box(
                css_classes=["bar_right_modules"],
                spacing=8,
                child=[
                    CpuUsageWidget(),
                    Separator(),
                    CpuTemperatureWidget(),
                    Separator(),
                    MemoryUsageWidget(),
                    SystemTray(include_separator=True),
                ],
            ),
        ),
    )
