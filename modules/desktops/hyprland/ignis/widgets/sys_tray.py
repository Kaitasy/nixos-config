from ignis import widgets
from ignis.services.system_tray import SystemTrayItem, SystemTrayService

from widgets.separator import Separator

sys_tray_service = SystemTrayService.get_default()


def system_tray_button(item: SystemTrayItem):
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return widgets.Button(
        css_classes=["sys_tray_button"],
        child=widgets.Box(
            child=[
                widgets.Icon(image=item.icon, pixel_size=19),
                menu,
            ]
        ),
        on_click=lambda _: item.activate(),
        on_right_click=lambda _: menu.popup() if menu else None,
    )


class SystemTray(widgets.Box):
    def __init__(self, include_separator: bool = False, spacing: int = 8):
        def update(items: list[SystemTrayItem]):
            children = []
            if len(items) > 0 and include_separator:
                children.append(Separator())

            children.append(
                widgets.Box(
                    vexpand=False,
                    hexpand=True,
                    valign="center",
                    spacing=12,
                    child=[system_tray_button(item) for item in items],
                )
            )

            return children

        super().__init__(
            css_classes=["sys_tray"],
            vexpand=False,
            hexpand=True,
            valign="center",
            spacing=spacing,
            child=sys_tray_service.bind(
                "items",
                transform=update,
            ),
        )
