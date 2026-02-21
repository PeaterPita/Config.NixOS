import QtQuick
import ".."

import QtQuick.Layouts

Item {
    id: resourceWidget

    // Placeholder data (you would hook this up to Process/bash scripts later)
    property int ramPercent: 45
    property string ramText: "5709 Mb"
    property int cpuPercent: 8
    property string cpuText: "8 %"

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Resource Usage"
                color: Theme.active.colFg
                font.bold: true
                font.pixelSize: 16
                Layout.fillWidth: true
            }
            Text {
                text: "󰇙"
                color: Theme.active.colMuted
                font.pixelSize: 16
                font.family: Theme.active.fontIcon
            }
        }

        // Memory Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: "Memory"
                color: Theme.active.colMuted
                font.pixelSize: 13
                Layout.preferredWidth: 60
            }

            // The Dashed Bar implementation
            Row {
                Layout.fillWidth: true
                spacing: 2
                Repeater {
                    model: 40 // Total number of dashes
                    Rectangle {
                        width: 3
                        height: 12
                        radius: 1
                        // Color it bright if it's filled, dim if it's empty
                        color: (index / 40 * 100) < resourceWidget.ramPercent ? Theme.active.colCyan : Qt.rgba(1, 1, 1, 0.1)
                    }
                }
            }
            Text {
                text: resourceWidget.ramText
                color: Theme.active.colFg
                font.pixelSize: 13
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 60
            }
        }

        // CPU Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Text {
                text: "CPU usage"
                color: Theme.active.colMuted
                font.pixelSize: 13
                Layout.preferredWidth: 60
            }

            Row {
                Layout.fillWidth: true
                spacing: 2
                Repeater {
                    model: 40
                    Rectangle {
                        width: 3
                        height: 12
                        radius: 1
                        color: (index / 40 * 100) < resourceWidget.cpuPercent ? Theme.active.colCyan : Qt.rgba(1, 1, 1, 0.1)
                    }
                }
            }
            Text {
                text: resourceWidget.cpuText
                color: Theme.active.colFg
                font.pixelSize: 13
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: 60
            }
        }

        Item {
            Layout.fillHeight: true
        } // Pushes content up
    }
}
