import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

ModuleBase {
    id: mem

    property int memUsage: 0

    dropdownWidth: 140
    dropdownHeight: Theme.barHeight

    dropdownComponent: Component {
        Column {
            anchors.centerIn: parent
            Text {
                text: "Memory Usage"
                color: Theme.colYellow
                font.pixelSize: 18
            }
            Text {
                text: mem.memUsage + "%"
                color: Theme.colRed
                font.pixelSize: 11
                font.bold: true
            }
        }
    }
    // MEM Process
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                mem.memUsage = Math.round(100 * used / total);
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }

    Text {
        text: ""
        color: Theme.colFg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }
}
