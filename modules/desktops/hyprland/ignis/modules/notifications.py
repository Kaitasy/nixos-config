from ignis import widgets
from ignis.app import IgnisApp

app = IgnisApp.get_initialized()


def NotificationTray(monitor: int) -> widgets.Window:
    try:
        window = app.get_window("shell-notifications")
        if window.monitor != monitor:
            window.destroy()
        else:
            return window
    except Exception:
        pass

    return widgets.Window(
        monitor=monitor,
        namespace="shell-notifications",
        anchor=["top", "right"],
        exclusivity="exclusive",
        layer="top",
        child=widgets.Box(
            vertical=True,
            css_classes=["notifications"],
            child=[
                # Header with title and 'Clear All' button
                widgets.CenterBox(
                    css_classes=["notifications_header"],
                    hexpand=True,
                    start_widget=widgets.Label(
                        label="Notifications",
                        css_classes=["notifications_header_title"],
                    ),
                    center_widget=widgets.Label(label=""),
                    end_widget=widgets.Button(
                        label="Clear All",
                        css_classes=["notifications_header_clear_button"],
                    ),
                ),
                # Separator
                widgets.Box(css_classes=["notifications_separator"]),
            ],
        ),
    )
