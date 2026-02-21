import QtQuick
import "../Components"
import QtQuick.Layouts
import ".."
import Quickshell.Hyprland

Row {
    spacing: 8
    Layout.alignment: Qt.AlignVCenter

    Text {
        text: "a"
        color: "white"
    }
    Repeater {
        model: 9

        Rectangle {
            property int wsId: index + 1
            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === wsId) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === wsId
            property bool hasWindows: workspace !== null

            width: wsContent.width + 12
            height: parent.height
            color: "transparent"

            Row {
                id: wsContent
                anchors.centerIn: parent
                spacing: 6

                Text {
                    text: wsId
                    color: isActive ? Theme.active.colCyan : (hasWindows ? Theme.active.colFg : Theme.active.colMuted)
                    font.pixelSize: Theme.active.fontSize
                    font.family: Theme.active.fontFamily
                    font.bold: true
                }

                Row {
                    spacing: 4
                    visible: hasWindows

                    Repeater {
                        model: Hyprland.workspaces.values.filter(c => c.id === wsId)
                        Text {
                            text: getAppIcon(modelData.class)
                            color: isActive ? Theme.active.colFg : Theme.active.colMuted
                            font.pixelSize: Theme.active.fontSize - 1
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width - 6
                height: 3
                color: isActive ? Theme.active.colPurple : "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsId)
            }
        }
    }

    function getAppIcon(className) {
        let cls = className.toLowerCase();

        // Browsers
        if (cls.includes("firefox") || cls.includes("browser"))
            return "";
        if (cls.includes("chrome") || cls.includes("brave"))
            return "";

        // Terminals
        if (cls.includes("kitty") || cls.includes("alacritty") || cls.includes("term"))
            return "";

        // Code & Editors
        if (cls.includes("code") || cls.includes("nvim") || cls.includes("vim"))
            return "󰨞";

        // Chat & Social
        if (cls.includes("discord") || cls.includes("vesktop"))
            return "󰙯";
        if (cls.includes("slack"))
            return "";

        // Media
        if (cls.includes("spotify"))
            return "";
        if (cls.includes("vlc") || cls.includes("mpv"))
            return "";

        // Default fallback for any app we don't recognize
        return "󰣆";
    }
}
