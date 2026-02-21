import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."
import "../Components"

ModuleBase {
    id: cpu

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // CPU usage
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var user = parseInt(parts[1]) || 0;
                var nice = parseInt(parts[2]) || 0;
                var system = parseInt(parts[3]) || 0;
                var idle = parseInt(parts[4]) || 0;
                var iowait = parseInt(parts[5]) || 0;
                var irq = parseInt(parts[6]) || 0;
                var softirq = parseInt(parts[7]) || 0;

                var total = user + nice + system + idle + iowait + irq + softirq;
                var idleTime = idle + iowait;

                if (cpu.lastCpuTotal > 0) {
                    var totalDiff = total - cpu.lastCpuTotal;
                    var idleDiff = idleTime - cpu.lastCpuIdle;
                    if (totalDiff > 0) {
                        cpu.cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff);
                    }
                }
                cpu.lastCpuTotal = total;
                cpu.lastCpuIdle = idleTime;
            }
        }
        Component.onCompleted: running = true
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }

    Text {
        text: ""
        color: Theme.active.colFg
        font.pixelSize: Theme.active.fontSize
        font.family: Theme.active.fontFamily
        font.bold: true
        Layout.fillWidth: true
        elide: Text.ElideRight
        Layout.rightMargin: 8
    }

    dropdownWidth: 80
    dropdownHeight: Theme.active.barHeight

    dropdownComponent: Component {

        Item {
            anchors.fill: parent

            RowLayout {
                anchors.fill: parent
                anchors.margins: 6

                Text {
                    text: "CPU"
                    color: Theme.active.colMuted
                    font.pixelSize: Theme.active.fontSize
                    font.family: Theme.active.fontFamily
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }

                Text {
                    text: cpu.cpuUsage + "%"
                    color: Theme.active.colRed
                    font.pixelSize: Theme.active.fontSize
                    font.family: Theme.active.fontFamily
                    font.bold: true
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
            }
        }
    }
}
