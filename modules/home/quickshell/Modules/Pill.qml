import QtQuick
import QtQuick.Shapes
import ".."

Item {
    id: root
    z: 1
    y: Theme.barHeight
    x: GlobalState.pillX

    Behavior on x {
        enabled: GlobalState.pillVisible
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutExpo
        }
    }

    width: GlobalState.pillWidth

    Behavior on width {
        enabled: GlobalState.pillVisible
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutExpo
        }
    }

    height: GlobalState.pillVisible ? GlobalState.pillHeight : 0
    Behavior on height {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutExpo
        }
    }
    Rectangle {
        id: pillMain
        anchors.fill: parent
        radius: 16
        color: Theme.colBg

        HoverHandler {
            id: pillHover
            onHoveredChanged: {
                GlobalState.pillHovered = hovered;

                if (hovered) {
                    pillCloseTimer.stop();
                } else {
                    pillCloseTimer.start();
                }
            }
        }

        Timer {
            id: pillCloseTimer
            interval: 1150
            onTriggered: {
                if (!GlobalState.pillHovered && GlobalState.activeModule && !GlobalState.activeModule.isHovered) {
                    GlobalState.pillVisible = false;
                    GlobalState.activeModule = null;
                }
            }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.min(12, root.height)
            visible: root.height > 0
            color: Theme.colBg
        }

        Loader {
            id: contentLoader
            anchors.fill: parent
            sourceComponent: GlobalState.pillContent
            opacity: GlobalState.pillVisible ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    property real filletHeight: Math.min(24, root.height / 3)
    property real filletWidth: Math.max(16, root.filletHeight * 1.5)

    Shape {
        anchors.right: pillMain.left
        anchors.top: pillMain.top

        width: root.filletWidth
        height: root.filletHeight

        // width: 16
        // height: 16
        opacity: root.height > 1 ? 1 : 0

        ShapePath {
            fillColor: Theme.colBg
            strokeColor: "transparent"
            startX: root.filletWidth
            startY: root.filletHeight

            PathCubic {
                x: 0
                y: 0
                control1X: root.filletWidth
                control1Y: root.filletHeight * 0.25
                control2X: root.filletWidth * 0.5
                control2Y: 0
            }

            PathLine {
                x: root.filletWidth
                y: 0
            }
            PathLine {
                x: root.filletWidth
                y: root.filletHeight
            }
        }
    }

    Shape {
        anchors.left: pillMain.right
        anchors.top: pillMain.top
        width: root.filletWidth
        height: root.filletHeight
        opacity: root.height > 5 ? 1 : 0

        ShapePath {
            fillColor: Theme.colBg
            strokeColor: "transparent"

            startX: 0
            startY: root.filletHeight

            PathCubic {
                x: root.filletWidth
                y: 0
                control1X: 0
                control1Y: root.filletHeight * 0.25
                control2X: root.filletWidth * 0.5
                control2Y: 0
            }

            PathLine {
                x: 0
                y: 0
            }
            PathLine {
                x: 0
                y: root.filletHeight
            }
        }
    }
}
