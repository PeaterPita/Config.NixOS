import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Modules"
import "../Components"
import ".."

Scope {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors {
                top: Theme.active.barTop ? true : false
                bottom: Theme.active.barTop ? false : true
                left: true
                right: true
            }

            implicitHeight: 800
            exclusiveZone: Theme.active.barHeight
            color: "transparent"

            margins {
                top: 0
                bottom: 0
                left: 0
                right: 0
            }

            Pill {
                id: pill

                y: Theme.active.barTop ? Theme.active.barHeight : bar.height - Theme.active.barHeight - height
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
                anchors.top: Theme.active.barTop ? parent.top : undefined
                anchors.bottom: Theme.active.barTop ? undefined : parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: Theme.active.barHeight
                color: Theme.active.colBg
                z: 2

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    // Repeater {
                    //     model: 9
                    //     Rectangle {
                    //         width: 20
                    //         height: parent.height
                    //         color: "transparent"
                    //
                    //         property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                    //         property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    //         property bool hasWindows: workspace !== null
                    //
                    //         Text {
                    //             text: index + 1
                    //             color: parent.isActive ? Theme.active.colCyan : (parent.hasWindows ? Theme.active.colCyan : Theme.active.colMuted)
                    //             font.pixelSize: Theme.active.fontSize
                    //             font.family: Theme.active.fontFamily
                    //             font.bold: true
                    //             anchors.centerIn: parent
                    //         }
                    //
                    //         Rectangle {
                    //             width: 20
                    //             height: 3
                    //             color: parent.isActive ? Theme.active.colPurple : Theme.active.colBg
                    //             anchors.horizontalCenter: parent.horizontalCenter
                    //             anchors.bottom: parent.bottom
                    //         }
                    //
                    //         MouseArea {
                    //             anchors.fill: parent
                    //             onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    //         }
                    //     }
                    // }

                    GradientText {
                        text: ""
                        font.pixelSize: 24
                        font.family: Theme.active.fontFamily
                        gradient: Theme.active.gradOrange
                        Layout.alignment: Qt.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            onClicked: GlobalState.controlCenterShow = !GlobalState.controlCenterShow
                        }
                    }

                    Workspaces {}

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
                            source: "../Modules/Kernel.qml"
                        }

                        Loader {
                            active: true
                            source: "../Modules/Vol.qml"
                        }

                        Text {
                            id: clockText
                            text: Qt.formatDateTime(new Date(), "MMM dd  •  HH:mm")
                            color: Theme.active.colFg
                            font.pixelSize: Theme.active.fontSize
                            font.family: Theme.active.fontFamily
                            font.bold: true

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "MMM dd  •  HH:mm")
                            }
                        }
                    }
                }
            }
        }
    }
}
