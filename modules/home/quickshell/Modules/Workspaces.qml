import QtQuick
import Quickshell.Io

Item {
    id: root
    implicitWidth: loader.implicitWidth
    implicitHeight: loader.implicitHeight

    property string compositor: ""

    Process {
        id: envProc
        command: ["sh", "-c", "[ -n \"$NIRI_SOCKET\" ] && echo niri && exit; " + "echo \"$XDG_CURRENT_DESKTOP\" | grep -qi kde && echo kde && exit; " + "[ -n \"$KDE_SESSION_VERSION\" ] && echo kde && exit; " + "echo unknown"]
        stdout: SplitParser {
            onRead: data => {
                var val = data.trim();
                if (val)
                    root.compositor = val;
            }
        }
        Component.onCompleted: running = true
    }

    Loader {
        id: loader
        source: {
            switch (root.compositor) {
            case "niri":
                return "WorkspacesNiri.qml";
            case "kde":
                return "WorkspacesKde.qml";
            default:
                return "";
            }
        }
    }
}
