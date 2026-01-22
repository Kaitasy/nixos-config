import subprocess

from ignis import utils
from ignis.services.network import NetworkService

from utils import bytes_to_human_readable
from widgets.icon_label import IconLabel

net_service = NetworkService.get_default()


class NetworkUsageWidget(IconLabel):
    def __init__(self, upload: bool = False, **kwargs):
        self.last = 0
        self.upload = upload

        # Get active network interface
        self.interface = (
            subprocess.check_output(["ip", "route", "show"]).decode().split(" ")[4]
        )

        super().__init__(
            css_classes=["network_usage"],
            halign="center",
            label="",
            icon="" if upload else "",
        )
        utils.Poll(1000, lambda x: self.update())

    def update(self):
        out = (
            open(
                f"/sys/class/net/{self.interface}/statistics/{'tx' if self.upload else 'rx'}_bytes"
            )
            .read()
            .strip()
        )
        b = int(out)
        diff = b - self.last
        self.set_label(f"{bytes_to_human_readable(diff)}/s")
        self.last = b


class VpnStatusWidget(IconLabel):
    def __init__(self):
        super().__init__("Disconnected", "")

        utils.Poll(
            1000,
            lambda x: self.set_label(
                "Connected" if net_service.vpn.is_connected else "Disconnected"
            ),
        )
