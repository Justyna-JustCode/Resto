import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "../style"
import "../components"

Button {
    id: button

    property var styleFont: Style.font.imageButton
    property string type

    QtObject {
        id: d
        property string path: "qrc:/resources/images/"
        property string extension: ".png"
    }

    iconSource: d.path + type + d.extension

    style: ButtonStyle {
        background: Rectangle {
            visible: control.text.length
            opacity: control.pressed ? 0.8 : 1

            color: "transparent"
            border.color: control.styleFont.color
            border.width: 1
            radius: control.styleFont.size/5
        }

        label: RowLayout {
            opacity: control.pressed ? 0.8 : 1

            Image {
                id: image
                Layout.preferredHeight: control.styleFont.size*1.5
                Layout.preferredWidth: (sourceSize.width/sourceSize.height)*Layout.preferredHeight

                source: control.iconSource
            }
            Label {
                id: text
                Layout.alignment: Qt.AlignVCenter

                fontStyle: control.styleFont

                text: control.text
            }
        }
    }
}
