import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

ModuleBase {
    id: kernel

    property string kernelVersion: "Linux"
    // Kernel version
    Process {
        id: kernelProc
        command: ["uname", "-r"]
        stdout: SplitParser {
            onRead: data => {
                if (data)
                    kernel.kernelVersion = data.trim();
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: kernelProc.running = true
    }

    Text {
        text: ""
        color: Theme.colFg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
    }

    dropdownWidth: 140
    dropdownHeight: Theme.barHeight

    dropdownComponent: Component {
        Column {
            anchors.centerIn: parent
            Text {
                text: kernel.kernelVersion
                color: Theme.colYellow
                font.pixelSize: 11
            }
        }
    }
}
