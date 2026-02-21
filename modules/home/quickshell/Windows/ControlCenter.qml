import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Modules"
import "../Components"
import "../Modules/Others"
import "../Widgets" as Widgets
import ".."

PanelWindow {
    id: controlCenter

    exclusiveZone: 0
    implicitWidth: mainRect.width
    implicitHeight: mainRect.height

    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }

    visible: GlobalState.controlCenterShow
    color: "transparent"

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)

        opacity: GlobalState.controlCenterShow ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: GlobalState.controlCenterShow = false
        }
    }

    Rectangle {
        id: mainRect
        width: 950
        height: 520

        anchors.centerIn: parent

        radius: 20
        color: "transparent"

        MouseArea {
            anchors.fill: parent
        }

        GridLayout {
            anchors.fill: parent
            anchors.margins: 20
            columns: 3
            columnSpacing: 16
            rowSpacing: 16

            Card {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 160

                Widgets.MediaModule {
                    anchors.fill: parent
                }
            }

            Card {

                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                Widgets.ResourceWidget {
                    anchors.fill: parent
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        text: "Stopwatch"
                        color: Theme.active.colMuted
                    }
                    Text {
                        text: "00:00"
                        color: Theme.active.colFg
                    }
                }
            }

            Card {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 160

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 16
                    RowLayout {
                        Text {
                            text: ""
                            color: Theme.active.colFg
                            font.family: Theme.active.fontIcon
                            font.pixelSize: 20
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 16
                            radius: 8
                            color: Theme.active.colFg
                        } // Fake Slider
                    }
                    RowLayout {
                        Text {
                            text: "󰃠"
                            color: Theme.active.colFg
                            font.family: Theme.active.fontIcon
                            font.pixelSize: 20
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            height: 16
                            radius: 8
                            color: Theme.active.colMuted
                        } // Fake Slider
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                Layout.preferredHeight: 120

                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        text: "City, Country"
                        color: Theme.active.colMuted
                    }
                    RowLayout {
                        Text {
                            text: "☀️"
                            font.pixelSize: 24
                        }
                        Text {
                            text: "15°C"
                            color: Theme.active.colFg
                            font.pixelSize: 24
                            font.bold: true
                        }
                    }
                }
            }

            Card {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 160

                Contrib {}
            }
        }
    }
}
