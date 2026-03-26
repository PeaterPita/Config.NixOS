import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    signal clicked

    implicitHeight: Theme.active.barHeight
    implicitWidth: contentContainer.implicitWidth + 5 * 2 + 4

    property Component dropdownComponent: null
    property real dropdownWidth: 150
    property real dropdownHeight: Theme.active.barHeight

    property bool isHovered: hoverArea.containsMouse

    function openPill() {
        if (!root.dropdownComponent)
            return;
        closeDelay.stop();
        GlobalState.activeModule = root;

        let coords = root.mapToItem(null, 0, 0);

        let windowWidth = root.Window.width;
        let margin = 12;

        GlobalState.pillWidth = root.dropdownWidth;
        GlobalState.pillHeight = root.dropdownHeight;

        let targetX = coords.x + (root.width / 2) - (GlobalState.pillWidth / 2);

        if (targetX < margin) {
            targetX = margin;
        } else if (targetX + GlobalState.pillWidth > windowWidth - margin) {
            targetX = windowWidth - margin - GlobalState.pillWidth;
        }

        GlobalState.pillX = targetX;
        GlobalState.pillContent = root.dropdownComponent;
        GlobalState.pillVisible = true;
    }

    Item {
        id: contentContainer
        anchors.centerIn: parent
        Layout.alignment: Qt.AlignVCenter
        default property alias content: contentContainer.data
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked();

            if (root.dropdownComponent) {
                if (GlobalState.activeModule === root) {
                    GlobalState.pillPinned = !GlobalState.pillPinned;
                } else {
                    root.openPill();
                    GlobalState.pillPinned = true;
                }
            }
        }

        Timer {
            id: closeDelay
            interval: 250
            onTriggered: {
                if (!GlobalState.pillPinned && GlobalState.activeModule === root && !root.isHovered && !GlobalState.pillHovered) {
                    GlobalState.pillVisible = false;
                    GlobalState.activeModule = null;
                }
            }
        }

        onEntered: {
            if (GlobalState.pillPinned)
                return;

            root.openPill();
        }

        onExited: {
            closeDelay.start();
        }
    }
}
