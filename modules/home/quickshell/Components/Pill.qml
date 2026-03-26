import QtQuick
import QtQuick.Shapes
import ".."

Item {
    id: root
    z: 1
    x: GlobalState.pillX

    Behavior on x {
        enabled: GlobalState.pillVisible
        SpringAnimation {
            spring: Theme.pillSpringX
            damping: Theme.pillDampingX
            mass: Theme.pillMassX
            epsilon: 0.5
        }
    }

    width: GlobalState.pillWidth

    Behavior on width {
        enabled: GlobalState.pillVisible
        SpringAnimation {
            spring: Theme.pillSpringWidth
            damping: Theme.pillDampingWidth
            mass: Theme.pillMassWidth
            epsilon: 0.5
        }
    }

    height: GlobalState.pillVisible ? GlobalState.pillHeight : 0
    Behavior on height {
        SpringAnimation {
            spring: Theme.pillSpringHeight
            damping: Theme.pillDampingHeight
            mass: Theme.pillMassHeight
            epsilon: 0.5
        }
    }

    Rectangle {
        id: pillMain
        anchors.fill: parent
        radius: 16
        color: Theme.active.colBg

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
            interval: 350
            onTriggered: {
                if (!GlobalState.pillPinned && !GlobalState.pillHovered && GlobalState.activeModule && !GlobalState.activeModule.isHovered) {
                    GlobalState.pillVisible = false;
                    GlobalState.activeModule = null;
                }
            }
        }

        Rectangle {
            anchors.top: Theme.active.barTop ? parent.top : undefined
            anchors.bottom: Theme.active.barTop ? undefined : parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.min(12, root.height)
            visible: root.height > 0
            color: Theme.active.colBg
        }

        Loader {
            id: contentLoader
            anchors.fill: parent
            sourceComponent: GlobalState.pillContent
            opacity: GlobalState.pillVisible && root.height > 8 ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    property real filletHeight: Math.min(24, root.height / 3)
    property real filletWidth: root.filletHeight * 1.5

    Shape {
        anchors.right: pillMain.left

        anchors.top: Theme.active.barTop ? pillMain.top : undefined
        anchors.bottom: Theme.active.barTop ? undefined : pillMain.bottom

        width: root.filletWidth
        height: root.filletHeight

        visible: root.height > 0
        transform: Scale {
            origin.y: root.filletHeight / 2
            yScale: Theme.active.barTop ? 1 : -1
        }

        ShapePath {
            fillColor: Theme.active.colBg
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

        anchors.top: Theme.active.barTop ? pillMain.top : undefined
        anchors.bottom: Theme.active.barTop ? undefined : pillMain.bottom

        width: root.filletWidth
        height: root.filletHeight

        visible: root.height > 0

        transform: Scale {
            origin.y: root.filletHeight / 2
            yScale: Theme.active.barTop ? 1 : -1
        }

        ShapePath {
            fillColor: Theme.active.colBg
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
