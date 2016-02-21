pragma Singleton
import QtQuick 2.5

QtObject {
    id: style

    property var background: QtObject {
        property string color: "white"
        property string image: "qrc:/resources/background.png"
    }
    property var decorative: QtObject {
        property string image: "qrc:/resources/pattern.png"
    }

    property var font: QtObject {
        property int size: 25
        property string family: loader.name
        property bool bold: true

        property var loader: FontLoader {
            id: loader
            source: "qrc:/resources/font.ttf"
        }

        property var header: font
    }

    property var timeBar: QtObject {
        property color color: "#2A7B42"
        property color backgroundColor: Qt.tint(Qt.lighter(color, 1.5), Qt.rgba(0.75,0.75,0.75, 0.5))
        property color secondaryColor: Qt.darker(color, 1.5)
        property color fontColor: "white"

        property var font: style.font

        property real gradientFactor: 1.25
    }

}
