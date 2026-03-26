import Quickshell
import QtQuick
import QtQuick.Layouts
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
                top: Theme.active.barTop
                bottom: !Theme.active.barTop
                left: true
                right: true
            }

            implicitHeight: 800
            exclusiveZone: Theme.active.barHeight
            color: "transparent"

            mask: Region {
                Region {
                    item: barRect
                }
                Region {
                    item: pill
                    y: pill.y
                    height: Math.max(pill.height, 1)
                }
            }

            Component.onCompleted: GlobalState.barRoot = bar.contentItem

            Rectangle {
                id: barRect
                anchors {
                    top: Theme.active.barTop ? parent.top : undefined
                    bottom: Theme.active.barTop ? undefined : parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: Theme.active.barHeight
                color: Theme.active.colBg
                z: 2

                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 10
                    }
                    spacing: 8

                    GradientText {
                        text: "󱄅"
                        font.pixelSize: 20
                        font.family: Theme.active.fontFamily
                        gradient: Theme.gradOrange
                        Layout.alignment: Qt.AlignVCenter

                        scale: launcherArea.pressed ? 0.8 : 1.0
                        Behavior on scale {
                            SpringAnimation {
                                spring: Theme.springStiffness
                                damping: Theme.springDamping
                            }
                        }

                        MouseArea {
                            id: launcherArea
                            anchors.fill: parent
                        }
                    }

                    Loader {
                        Layout.alignment: Qt.AlignVCenter
                        source: "../Modules/Workspaces.qml"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    RowLayout {
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

            Pill {
                id: pill
                z: 10
                y: Theme.active.barTop ? Theme.active.barHeight : bar.height - Theme.active.barHeight - pill.height
            }
        }
    }
}
