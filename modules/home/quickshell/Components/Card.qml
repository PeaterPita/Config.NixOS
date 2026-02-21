import QtQuick

Rectangle {
    id: root
    radius: 16
    color: "#1e1e2e"
    border.color: "#313244"
    border.width: 1

    default property alias contentItem: container.data

    Item {
        id: container
        anchors.fill: parent
        anchors.margins: 16
    }
}
