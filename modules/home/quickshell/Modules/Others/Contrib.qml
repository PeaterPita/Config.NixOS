import QtQuick
import QtQuick.Layouts
import "../Services"
import ".."

Item {
    id: contributionCalendar
    width: 300
    height: 60

    property var contribs: Github.contributions !== undefined ? Github.contributions : []

    function contributionColor(level) {
        if (level === 0)
            return Theme.colCyan;
        if (level === 1)
            return Theme.colCyan;
        if (level === 2)
            return Theme.colPurple;
        if (level === 3)
            return Theme.colRed;
        return Theme.colFg; // fallback for level 4+
    }

    GridLayout {
        anchors.centerIn: parent
        rows: 7
        columns: 40
        rowSpacing: 2
        columnSpacing: 2

        RowLayout {
            spacing: 2

            Repeater {
                model: 40  // weeks
                delegate: ColumnLayout {
                    spacing: 2

                    // Manually pass the week index
                    property int weekIndex: index

                    Repeater {
                        model: 7  // days
                        delegate: Rectangle {
                            width: 7
                            height: 7
                            radius: 2

                            property int realIndex: weekIndex * 7 + index
                            color: contributionColor(contribs[realIndex]?.level || 0)

                            MouseArea {
                                id: infoMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                // StyledToolTip {
                                //     content: `${contribs[realIndex]?.count || 0} commits on ${contribs[realIndex]?.date || "unknown"}`
                                //     extraVisibleCondition: infoMouseArea.containsMouse
                                // }
                            }
                        }
                    }
                }
            }
        }
    }
}
