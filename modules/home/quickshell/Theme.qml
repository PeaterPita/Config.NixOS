pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property QtObject active: darkTop

    QtObject {
        id: darkTop
        // Theme colors
        property color colBg: "#222222"
        property color colFg: "#a9b1d6"
        property color colMuted: "#444b6a"
        property color colCyan: "#0db9d7"
        property color colPurple: "#ad8ee6"
        property color colRed: "#f7768e"
        property color colYellow: "#e0af68"
        property color colBlue: "#7aa2f7"

        // Gradients
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
        // Font
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14

        // Bar
        property int barHeight: 30
        property bool barTop: true
    }

    QtObject {
        id: bottom
        // Theme colors
        property color colBg: "#235EDC"
        property color colFg: "#111111"
        property color colMuted: "#888888"
        property color colCyan: "#0088cc"
        property color colPurple: "#8800cc"
        property color colRed: "#cc0000"
        property color colYellow: "#cc8800"
        property color colBlue: "#0044cc"

        // Font
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSize: 14

        // Bar
        property int barHeight: 40
        property bool barTop: false
    }
}
