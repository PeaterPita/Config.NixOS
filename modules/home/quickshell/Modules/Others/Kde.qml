import Quickshell
import Quickshell.Io
import QtQuick
import ".."

// ##########################################################################################################
// #                        This is purely an example of how other peoples snippets                         #
// #                            can be used and modified to fit into my system                              #
// #                                            Original Code:                                              #
// # import Quickshell                                                                                      #
// # import Quickshell.Io                                                                                   #
// # import QtQuick                                                                                         #
// #                                                                                                        #
// # Item {                                                                                                 #
// #    id: root                                                                                            #
// #                                                                                                        #
// #    Process {                                                                                           #
// #        id: procShowDesktop                                                                             #
// #     // This can be changed to invoke any kwin script                                                   #
// #        command: ["qdbus", "org.kde.kglobalaccel", "/component/kwin", "invokeShortcut", "Show Desktop"] #
// #        stderr: StdioCollector {                                                                        #
// #            onStreamFinished: () => { if(this.text.length > 0)                                          #
// #                console.warn( this.text )                                                               #
// #            }                                                                                           #
// #        }                                                                                               #
// #    }                                                                                                   #
// #                                                                                                        #
// #    MouseArea {                                                                                         #
// #    //  I like to use MouseArea since it's simpler and can be used for                                  #
// #        hover-styling all in one component                                                              #
// #        id: triggerShowDesktop                                                                          #
// #        anchors.fill: parent                                                                            #
// #        acceptedButtons: Qt.LeftButton                                                                  #
// #        onPressed: procShowDesktop.running = true                                                       #
// #    }                                                                                                   #
// # }                                                                                                      #
// ##########################################################################################################

ModuleBase {
    id: kde

    Process {
        id: procShowDesktop
        // This can be changed to invoke any kwin script
        command: ["qdbus", "org.kde.kglobalaccel", "/component/kwin", "invokeShortcut", "Show Desktop"]
        stderr: StdioCollector {
            onStreamFinished: () => {
                if (this.text.length > 0)
                    console.warn(this.text);
            }
        }
    }
    onClicked: procShowDesktop.running = true
    dropdownWidth: 120
    dropdownHeight: 80
    dropdownComponent: Component {
        Column {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: "System Info"
                color: Theme.colYellow
                font.family: Theme.fontText
                font.pixelSize: Theme.sizeText
            }
            Text {
                text: "Power Off"
                color: Theme.colRed
                font.family: Theme.fontText
                font.pixelSize: Theme.sizeText
                font.bold: true
            }
        }
    }
    Text {
        text: ""
        color: Theme.colFg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true
        elide: Text.ElideRight
    }
}
