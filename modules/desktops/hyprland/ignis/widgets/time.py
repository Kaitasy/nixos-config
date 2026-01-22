import datetime

from ignis import utils, widgets


class TimeWidget(widgets.Box):
    def __init__(self):
        hour_label = widgets.Label(css_classes=["time_num"])
        minute_label = widgets.Label(css_classes=["time_num"])

        def update_labels():
            hour_label.set_property("label", datetime.datetime.now().strftime("%H"))
            minute_label.set_property("label", datetime.datetime.now().strftime("%M"))

        utils.Poll(1000, lambda x: update_labels())
        super().__init__(
            spacing=4,
            css_classes=["time_widget"],
            child=[
                hour_label,
                widgets.Label(css_classes=["time_sep"], label=""),
                minute_label,
            ],
        )


class DateTimeWidget(widgets.Label):
    def __init__(self, format: str, interval: int):
        super().__init__(css_classes=["datetime_widget"])
        utils.Poll(
            timeout=interval,
            callback=lambda x: self.set_property(
                "label", datetime.datetime.now().strftime(format)
            ),
        )
