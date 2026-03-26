import QtQuick
import Quickshell.Wayland
import ".."

Row {
    id: root
    spacing: 4

    function iconName(appId) {
        if (!appId)
            return "application-x-executable";
        var lower = appId.toLowerCase();
        var parts = lower.split(".");
        return parts.length >= 3 ? parts[parts.length - 1] : lower;
    }

    Repeater {
        model: ToplevelManager.toplevels

        Rectangle {
            id: taskItem
            required property var modelData

            property bool active: modelData.activated

            height: Theme.active.barHeight - 4
            width: Math.min(taskRow.implicitWidth + 16, 200)
            color: active ? Qt.rgba(1, 1, 1, 0.13) : (hoverArea.containsMouse ? Qt.rgba(1, 1, 1, 0.07) : "transparent")
            radius: 5

            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }

            Rectangle {
                width: parent.width - 8
                height: 2
                radius: 1
                color: taskItem.active ? Theme.active.colCyan : "transparent"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 1
                }
            }

            Row {
                id: taskRow
                anchors {
                    left: parent.left
                    leftMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                spacing: 5

                Image {
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image://icon/" + root.iconName(taskItem.modelData.appId)
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        var t = taskItem.modelData.title;
                        return (t && t.length > 22) ? t.substring(0, 22) + "…" : (t || taskItem.modelData.appId);
                    }
                    color: taskItem.active ? Theme.active.colFg : Theme.active.colMuted
                    font.pixelSize: Theme.active.fontSize - 1
                    font.family: Theme.active.fontFamily
                }
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: taskItem.modelData.activate()
            }
        }
    }
}
