from ignis import widgets
from ignis.services.hyprland import HyprlandService, HyprlandWorkspace

hypr_service = HyprlandService.get_default()

workspace_labels = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]


def hyprland_workspace_button(workspace_id: int, active: bool) -> widgets.Button:
    return widgets.Button(
        label=workspace_labels[workspace_id - 1],
        css_classes=["workspaces_button", "active" if active else "inactive"],
        on_click=lambda x: hypr_service.switch_to_workspace(workspace_id),
        valign="fill",
        vexpand=True,
    )


class HyprlandWorkspaces(widgets.Box):
    def get_workspace_buttons(
        self, workspaces: list[HyprlandWorkspace], active_workspace: HyprlandWorkspace
    ) -> list[widgets.Button]:
        buttons = []

        # Always show at least 5 because I like the look
        for i in range(1, 6):
            buttons.append(hyprland_workspace_button(i, i == active_workspace.id))

        for workspace in workspaces:
            if workspace.id > 5:
                buttons.append(
                    hyprland_workspace_button(
                        workspace.id, workspace.id == active_workspace.id
                    )
                )

        return buttons

    def __init__(self, **kwargs):
        super().__init__(
            css_classes=["workspaces"],
            hexpand=True,
            valign="center",
            vexpand=True,
            spacing=10,
            child=hypr_service.bind_many(
                ["workspaces", "active_workspace"],
                transform=lambda workspaces,
                active_workspace: self.get_workspace_buttons(
                    workspaces, active_workspace
                ),
            ),
            **kwargs,
        )
