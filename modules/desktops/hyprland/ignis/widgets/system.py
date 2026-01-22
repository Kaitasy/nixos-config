import psutil
from ignis import utils

from utils import bytes_to_human_readable
from widgets.icon_label import IconLabel


class CpuUsageWidget(IconLabel):
    def __init__(self):
        super().__init__("0.0%", "")
        utils.Poll(1000, lambda x: self.update())

    def update(self):
        self.set_label(f"{psutil.cpu_percent():.1f}%")


class CpuTemperatureWidget(IconLabel):
    def __init__(self):
        super().__init__("0.0%", "")
        utils.Poll(1000, lambda x: self.update())

    def update(self):
        self.set_label(f"{psutil.sensors_temperatures()['k10temp'][0].current:.1f}°C")


class MemoryUsageWidget(IconLabel):
    def __init__(self):
        super().__init__("0.0%", "")
        utils.Poll(1000, lambda x: self.update())

    def update(self):
        self.set_label(f"{bytes_to_human_readable(psutil.virtual_memory().used)}")
