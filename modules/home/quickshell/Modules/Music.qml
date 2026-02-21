import QtQuick
import "../Components"
import "../Widgets"
import ".."

ModuleBase {
    id: music

    Text {
        text: ""
        color: Theme.active.colFg
        font.pixelSize: Theme.active.fontSize
        font.family: Theme.active.fontFamily
        font.bold: true
    }

    dropdownWidth: 320
    dropdownHeight: 120

    dropdownComponent: Component {
        Item {
            anchors.fill: parent

            MediaModule {
                anchors.fill: parent
            }
        }
    }
}
