import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

ModuleBase {
    id: volume

    property int volumeLevel: 0
    // Volume level (wpctl for PipeWire)
    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var match = data.match(/Volume:\s*([\d.]+)/);
                if (match) {
                    volume.volumeLevel = Math.round(parseFloat(match[1]) * 100);
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: volProc.running = true
    }

    Text {
        text: ""
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
                text: "Vol: " + volume.volumeLevel + "%"
                color: Theme.colPurple
                font.pixelSize: 18
            }
        }
    }
}
