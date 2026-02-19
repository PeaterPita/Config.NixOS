import QtQuick
import ".."

Item {
    id: root
    signal clicked

    implicitWidth: contentContainer.width
    implicitHeight: contentContainer.height

    default property alias contentItem: contentContainer.data

    property Component dropdownComponent: null
    property real dropdownWidth: 150
    property real dropdownHeight: Theme.barHeight

    property bool isHovered: hoverArea.containsMouse

    Item {
        id: contentContainer
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()

        Timer {
            id: closeDelay
            interval: 150
            onTriggered: {
                if (GlobalState.activeModule === root && !root.isHovered && !GlobalState.pillHovered) {
                    GlobalState.pillVisible = false;
                    GlobalState.activeModule = null;
                }
            }
        }

        onEntered: {
            if (root.dropdownComponent) {
                closeDelay.stop();
                GlobalState.activeModule = root;

                let coords = root.mapToItem(null, 0, 0);

                // GlobalState.moduleCenterX = coords.x + (root.width / 2);

                GlobalState.pillWidth = root.dropdownWidth;
                GlobalState.pillHeight = root.dropdownHeight;

                GlobalState.pillX = coords.x + (root.width / 2) - (GlobalState.pillWidth / 2);
                GlobalState.pillContent = root.dropdownComponent;
                GlobalState.pillVisible = true;
            }
        }

        onExited: {
            closeDelay.start();
        }
    }
}
