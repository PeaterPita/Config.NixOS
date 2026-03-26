pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property QtObject active: darkTop

    readonly property real springStiffness: 6.5
    readonly property real springDamping: 0.72
    readonly property real springMass: 0.6

    readonly property real pillSpringX: 7.0
    readonly property real pillDampingX: 0.65
    readonly property real pillMassX: 0.8

    readonly property real pillSpringWidth: 6.0
    readonly property real pillDampingWidth: 0.70
    readonly property real pillMassWidth: 0.8

    readonly property real pillSpringHeight: 5.0
    readonly property real pillDampingHeight: 0.35
    readonly property real pillMassHeight: 0.7

    property Gradient gradOrange: Gradient {
        GradientStop {
            position: 0.0
            color: "#ff9e64"
        }
        GradientStop {
            position: 1.0
            color: "#e0af68"
        }
    }

    property Gradient gradGreen: Gradient {
        GradientStop {
            position: 0.0
            color: "#9ece6a"
        }
        GradientStop {
            position: 1.0
            color: "#73daca"
        }
    }

    QtObject {
        id: darkTop
        property color colBg: "#222222"
        property color colFg: "#a9b1d6"
        property color colMuted: "#444b6a"
        property color colCyan: "#0db9d7"
        property color colPurple: "#ad8ee6"
        property color colRed: "#f7768e"
        property color colYellow: "#e0af68"
        property color colBlue: "#7aa2f7"

        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14

        property int barHeight: 30
        property bool barTop: true
    }

    QtObject {
        id: bottom
        property color colBg: "#235EDC"
        property color colFg: "#111111"
        property color colMuted: "#888888"
        property color colCyan: "#0088cc"
        property color colPurple: "#8800cc"
        property color colRed: "#cc0000"
        property color colYellow: "#cc8800"
        property color colBlue: "#0044cc"

        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14

        property int barHeight: 40
        property bool barTop: false
    }
}
