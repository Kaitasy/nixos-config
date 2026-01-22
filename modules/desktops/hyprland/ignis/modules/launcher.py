from ignis import widgets
from ignis.services.applications import ApplicationsService
from ignis.window_manager import WindowManager

app_service = ApplicationsService.get_default()
window_manager = WindowManager.get_default()


def Launcher() -> widgets.Window:
    # Show existing window if available
    try:
        window = window_manager.get_window("shell-launcher")
        window.close()
    except Exception:
        pass

    input_box = widgets.Entry(
        on_accept=lambda x: print("execute"),
        on_change=lambda x: app_service.notify("apps"),
    )

    def get_app_list(apps) -> list[widgets.Label]:
        x = [
            widgets.Label(label=app.name)
            for app in (
                len(input_box.text) > 0
                and app_service.search(apps, input_box.text)
                or apps
            )
        ]
        return x[:10]

    window = widgets.Window(
        namespace="shell-launcher",
        layer="overlay",
        anchor=["top"],
        kb_mode="exclusive",
        popup=True,
        exclusivity="normal",
        child=widgets.Box(
            css_classes=["launcher"],
            hexpand=True,
            vexpand=True,
            vertical=True,
            child=[
                input_box,
                widgets.Box(css_classes=["launcher_separator"]),
                widgets.Box(
                    vertical=True,
                    spacing=2,
                    child=app_service.bind(
                        "apps",
                        transform=lambda apps: get_app_list(apps),
                    ),
                ),
            ],
        ),
    )

    input_box.grab_focus()
    return window
