import QtQuick 2.0
import "../style"
import "helpers"

Item {
    property int minValue: 0
    property int maxValue: 100
    property int value: 0

    implicitHeight: text.font.pixelSize*1.4
    implicitWidth: 200

    QtObject {
        id: d

        property bool isExcess: value > maxValue
        property real valuePercent: isExcess ? maxValue/value : value/maxValue

        function formatTime(timeSecs) {
            var hours, mins, secs
            secs = timeSecs%60
            mins = (Math.floor(timeSecs/60))%60
            hours = Math.floor( (Math.floor(timeSecs/60))/60 )

            var hoursStr, minsStr, secsStr
            secsStr = secs > 9 ? secs : '0' + secs
            minsStr = mins > 9 ? mins : '0' + mins
            hoursStr = hours > 9 ? hours : '0' + hours

            return hoursStr + ':' + minsStr + ':' + secsStr
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent

        color: Style.timeBar.backgroundColor
        border.color: Style.timeBar.color
        border.width: 1
    }
    Rectangle {
        id: progress
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        gradient: BarGradient { color: Style.timeBar.color }

        width: d.valuePercent * parent.width
    }
    Rectangle {
        id: excess
        anchors {
            left: progress.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        visible: d.isExcess

        gradient: BarGradient { color: Style.timeBar.secondaryColor }
    }

    Label {
        id: text
        anchors.fill: parent

        fontStyle: Style.timeBar.font

        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        text: d.formatTime(value) + " / " +
              d.formatTime(maxValue)

        BarTextGradient {
            value: d.valuePercent
        }
    }
}

