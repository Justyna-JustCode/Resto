import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../style"

RowLayout {
    property color currentColor
    property alias availableColors: repeater.model

    Repeater {
        id: repeater

        Rectangle {
            property bool isSelected: Qt.colorEqual(modelData, currentColor)
            color: modelData

            width: Style.colorPicker.itemSize
            height: width

            border.width: isSelected
                          ? Style.colorPicker.activeBorderWidth
                          : Style.colorPicker.inactiveBorderWidth
            border.color: isSelected
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
