import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property alias text: label.text
    property alias font: label.font

    property Gradient gradient

    property bool fillWidth: false

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    Text {
        id: label
        visible: false
        color: "white"
        elide: Text.ElideRight
        width: root.fillWidth ? parent.width : implicitWidth
    }

    LinearGradient {
        anchors.fill: label
        source: label
        gradient: root.gradient
        start: Qt.point(0, 0)
        end: Qt.point(width, 0)
    }
}
