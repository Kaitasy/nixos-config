from ignis.widgets import Widget


class Separator(Widget.Label):
    def __init__(self):
        super().__init__(label="", css_classes=["separator"])
