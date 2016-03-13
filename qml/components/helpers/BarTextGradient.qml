import QtQuick 2.0
import QtGraphicalEffects 1.0
import "../../style"

LinearGradient {
    property real value

    QtObject {
        id: d
        readonly property real middleDiff: 0.0001
    }

    anchors.fill: parent
    source: parent

    start: Qt.point(0, 0)
    end: Qt.point(width, 0)

    gradient: Gradient {
        GradientStop { position: 0; color: Style.timeBar.font.color }
        GradientStop { position: value-d.middleDiff; color: Style.timeBar.font.color }
        GradientStop { position: value+d.middleDiff; color: Style.timeBar.color }
        GradientStop { position: 1; color: Style.timeBar.color }
    }
}
