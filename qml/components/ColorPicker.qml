import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../style"

RowLayout {
    property color currentColor
    property alias availableColors: repeater.model

    Repeater {
        id: repeater

        Rectangle {
            color: modelData

            width: Style.colorPicker.itemSize
            height: width

            border.width: Style.colorPicker.borderWidth
            border.color: Qt.colorEqual(modelData, currentColor)
                          ? Style.colorPicker.activeColor
                          : Style.colorPicker.inactiveColor

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    currentColor = modelData
                }
            }
        }
    }
}
