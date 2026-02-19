import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Modules"
import ".."

Scope {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 300
            exclusiveZone: Theme.barHeight
            color: "transparent"

            margins {
                top: 0
                bottom: 0
                left: 0
                right: 0
            }

            Pill {
                id: pill
            }

            mask: Region {
                Region {
                    item: realBar
                }

                Region {
                    item: pill
                }
            }
            Rectangle {
                id: realBar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Theme.barHeight
                color: Theme.colBg
                z: 2

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    Text {
                        text: ""
                        color: Theme.colCyan
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                        }
                    }

                    Spacer {}

                    Repeater {
                        model: 9
                        Rectangle {
                            width: 20
                            height: parent.height
                            color: "transparent"

                            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                            property bool hasWindows: workspace !== null

                            Text {
                                text: index + 1
                                color: parent.isActive ? Theme.colCyan : (parent.hasWindows ? Theme.colCyan : Theme.colMuted)
                                font.pixelSize: Theme.fontSize
                                font.family: Theme.fontFamily
                                font.bold: true
                                anchors.centerIn: parent
                            }

                            Rectangle {
                                width: 20
                                height: 3
                                color: parent.isActive ? Theme.colPurple : Theme.colBg
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + (index + 1))
                            }
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Row {
                        spacing: 12
                        Layout.alignment: Qt.AlignVCenter

                        Loader {
                            active: true
                            source: "../Modules/Music.qml"
                        }
                        Loader {
                            active: true
                            source: "../Modules/Cpu.qml"
                        }

                        Loader {
                            active: true
                            source: "../Modules/Memory.qml"
                        }

                        Loader {
                            active: true
                            source: "../Modules/Disk.qml"
                        }

                        Loader {
                            active: true
                            source: "../Modules/Kernel.qml"
                        }

                        Loader {
                            active: true
                            source: "../Modules/Vol.qml"
                        }

                        Text {
                            id: clockText
                            text: Qt.formatDateTime(new Date(), "MMM dd  •  HH:mm")
                            color: Theme.colFg
                            font.pixelSize: Theme.fontSize
                            font.family: Theme.fontFamily
                            font.bold: true

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "MMM dd  |  HH:mm")
                            }
                        }
                    }
                }
            }
        }
    }
}
