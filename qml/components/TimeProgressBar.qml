import QtQuick 2.0

Item {
    property int minValue: 0
    property int maxValue: 100
    property int value: 0
    property alias style: style

    implicitHeight: 15
    implicitWidth: 30

    QtObject {
        id: style

        property color color: "#2A7B42"
        property color secondaryColor: "#013E13"
        property color backgroundColor: "#7AB88D"
        property color fontColor: "white"
        property font font
    }
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

        color: style.backgroundColor
    }
    Rectangle {
        id: progress
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        color: style.color

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

        color: style.secondaryColor
    }

    Text {
        anchors.fill: parent

        color: style.fontColor
        font: style.font

        elide: Text.ElideRight
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        text: d.formatTime(value) + " / " +
              d.formatTime(maxValue)
    }
}

