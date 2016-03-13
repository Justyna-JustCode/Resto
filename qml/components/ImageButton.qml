import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Button {
    id: button

    property string type
    property real scale: 1

    QtObject {
        id: d
        property string path: "qrc:/resources/images/"
        property string extension: ".png"
    }

    style: ButtonStyle {
        background: Image {
            source: d.path + type + d.extension
            scale: button.scale

            Colorize {
                anchors.fill: parent
                source: parent

                hue: 0
                saturation: 0
                lightness: control.pressed ? 0.2 : 0
            }
        }
    }
}
