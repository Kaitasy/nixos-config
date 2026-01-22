from ignis import widgets


class IconLabel(widgets.Box):
    def __init__(self, label: str, icon: str, **kwargs):
        self.label = widgets.Label(label=label, css_classes=["icon_label_label"])
        self.icon = widgets.Label(label=icon, css_classes=["icon_label_icon"])

        css_classes = ["icon_label"] + (
            kwargs["css_classes"] if "css_classes" in kwargs else []
        )
        if "css_classes" in kwargs:
            kwargs.pop("css_classes")

        super().__init__(
            spacing=14,
            hexpand=True,
            css_classes=css_classes,
            child=[self.label, self.icon],
            **kwargs,
        )

    def set_label(self, label: str):
        self.label.set_property("label", label)

    def set_icon(self, icon: str):
        self.icon.set_property("label", icon)
