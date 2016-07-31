import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../style"
import "../components"

Switch {
    property string onStateName: qsTr("On")
    property string offStateName: qsTr("Off")

    style: SwitchStyle {
        handle: Rectangle {
            id: handle
            implicitWidth: control.width*0.6
            implicitHeight: Style.switchControl.font.size*1.5

            color: Style.switchControl.handleColor
            border.width: 2
            border.color: text.fontStyle.color

            radius: Style.switchControl.font.size/2

            Label {
                id: text
                anchors {
                    centerIn: parent
                }
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                fontStyle: Style.switchControl.font

                text: control.checked ? control.onStateName : control.offStateName
            }
        }
        groove: Rectangle {
            implicitWidth: 90
            implicitHeight: Style.switchControl.font.size*1.5

            border.width: Style.switchControl.borderWidth
            border.color: Style.switchControl.handleColor

            radius: Style.switchControl.font.size/2

            color: control.pressed
                   ? Qt.darker(Style.switchControl.backgroundColor, 1.1)
                   : Style.switchControl.backgroundColor
        }
    }
}
