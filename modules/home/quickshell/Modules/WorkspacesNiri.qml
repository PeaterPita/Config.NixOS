import QtQuick
import Quickshell.Io
import ".."

// Workspace groups — only occupied workspaces, each showing app icons.
// Click an icon  → focus that window
// Click anywhere → switch to that workspace
Row {
    id: root
    spacing: 6

    property var workspaces: []
    property var windows: []

    // Only workspaces with at least one window, sorted by index.
    // Attach the matching windows list to each workspace object.
    property var activeWorkspaces: {
        return root.workspaces
            .filter(ws => root.windows.some(w => w.workspace_id === ws.id))
            .sort((a, b) => a.idx - b.idx)
            .map(ws => Object.assign({}, ws, {
                appWindows: root.windows.filter(w => w.workspace_id === ws.id)
            }))
    }

    // Resolve icon name from Wayland/niri appId.
    // "org.mozilla.firefox" -> "firefox", "kitty" -> "kitty"
    function iconName(appId) {
        if (!appId) return "application-x-executable"
        var lower = appId.toLowerCase()
        var parts = lower.split(".")
        return parts.length >= 3 ? parts[parts.length - 1] : lower
    }

    // --- IPC processes ---

    Process {
        id: wsProc
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.trim()) return
                try { root.workspaces = JSON.parse(data.trim()) }
                catch (e) { console.warn("WorkspacesNiri: workspace parse error:", e) }
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: winProc
        command: ["niri", "msg", "--json", "windows"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.trim()) return
                try { root.windows = JSON.parse(data.trim()) }
                catch (e) { console.warn("WorkspacesNiri: window parse error:", e) }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            wsProc.running = true
            winProc.running = true
        }
    }

    Process {
        id: focusSwitchProc
        property int targetIdx: 1
        command: ["niri", "msg", "action", "focus-workspace", String(targetIdx)]
    }

    Process {
        id: focusWindowProc
        property var targetId: 0
        command: ["niri", "msg", "action", "focus-window", "--id", String(targetId)]
    }

    // --- Workspace groups ---

    Repeater {
        model: root.activeWorkspaces

        Rectangle {
            id: wsItem
            required property var modelData

            property bool isActive: modelData.is_focused

            height: Theme.active.barHeight - 4
            width: wsRow.implicitWidth + 14
            color: isActive ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
            radius: 5

            Behavior on color { ColorAnimation { duration: 100 } }

            // Active indicator
            Rectangle {
                width: parent.width - 8
                height: 2
                radius: 1
                color: wsItem.isActive ? Theme.active.colPurple : "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 1
                }
            }

            Row {
                id: wsRow
                anchors { left: parent.left; leftMargin: 7; verticalCenter: parent.verticalCenter }
                spacing: 4

                // Workspace label
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: wsItem.modelData.name ?? String(wsItem.modelData.idx)
                    color: wsItem.isActive ? Theme.active.colCyan : Theme.active.colMuted
                    font.pixelSize: Theme.active.fontSize - 2
                    font.family: Theme.active.fontFamily
                    font.bold: true
                }

                // Divider
                Rectangle {
                    width: 1; height: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.active.colMuted
                    opacity: 0.5
                }

                // App icons
                Row {
                    spacing: 3
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: wsItem.modelData.appWindows

                        Item {
                            id: iconItem
                            required property var modelData
                            width: 18; height: 18

                            Image {
                                anchors.centerIn: parent
                                width: 16; height: 16
                                source: "image://icon/" + root.iconName(iconItem.modelData.app_id)
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                opacity: iconItem.modelData.is_focused ? 1.0 : 0.65

                                Behavior on opacity { NumberAnimation { duration: 100 } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse => {
                                    mouse.accepted = true
                                    focusWindowProc.targetId = iconItem.modelData.id
                                    focusWindowProc.running = true
                                }
                            }
                        }
                    }
                }
            }

            // Background click switches workspace (icons handle their own clicks above)
            MouseArea {
                anchors.fill: parent
                z: -1
                onClicked: {
                    focusSwitchProc.targetIdx = wsItem.modelData.idx
                    focusSwitchProc.running = true
                }
            }
        }
    }
}
