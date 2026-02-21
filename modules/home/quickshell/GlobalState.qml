pragma Singleton
import QtQuick

QtObject {

    // PILL
    property int pillX: 0
    property Component pillContent: null
    property bool pillVisible: false
    property int pillWidth: 0
    property int pillHeight: 30
    property var activeModule: null
    property bool pillHovered: false

    property bool pillPinned: false

    // Control Center
    property bool controlCenterShow: false
}
