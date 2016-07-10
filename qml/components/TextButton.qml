import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "../style"
import "../components"

Button {
    id: button

    property var styleFont: Style.font.textButton
    tooltip: text

    style: ButtonStyle {
        background: Rectangle {
            opacity: control.pressed ? 0.8 : 1

            color: "transparent"
            border.color: control.styleFont.color
            border.width: 1
            radius: control.styleFont.size/5
        }

        label: GridLayout {
            opacity: control.pressed ? 0.8 : 1

            Label {
                id: text
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: control.styleFont.size/2
                Layout.rightMargin: control.styleFont.size/2
                Layout.topMargin: control.styleFont.size/4
                Layout.bottomMargin: control.styleFont.size/4

                fontStyle: control.styleFont

                text: control.text
            }
        }
    }
}
