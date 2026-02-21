import QtQuick
import "../Components"
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
        color: Theme.active.colFg
        font.pixelSize: Theme.active.fontSize
        font.family: Theme.active.fontFamily
        font.bold: true
    }

    dropdownWidth: 180
    dropdownHeight: Theme.active.barHeight

    dropdownComponent: Component {

        Item {
            anchors.fill: parent

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 12

                GradientText {
                    id: dateText
                    text: Qt.formatDateTime(new Date(), "ddd MMM d")
                    font.pixelSize: Theme.active.fontSize
                    font.family: Theme.active.fontFamily
                    gradient: Theme.active.gradOrange
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: "|"
                    color: Theme.active.colMuted
                    font.pixelSize: Theme.active.fontSize
                    Layout.alignment: Qt.AlignVCenter
                }
                Text {
                    id: timeText
                    text: Qt.formatDateTime(new Date(), "h:mm AP")
                    color: Theme.active.colFg
                    font.pixelSize: Theme.active.fontSize
                    font.family: Theme.active.fontFamily
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}
