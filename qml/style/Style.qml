pragma Singleton
import QtQuick 2.5
import "."

QtObject {
    id: style

    property color mainColor: "#19886f"

    property var background: QtObject {
        property string color: "white"
        property string image: "qrc:/resources/images/background.png"
        property real opacity: 0.8
    }
    property var decorative: QtObject {
        property string image: "qrc:/resources/images/pattern.png"
    }

    property var font: QtObject {
        property var text: StyleFont {}
        property var header: StyleFont {
            size: font.text*1.2
            bold: true
            italic: true
        }
    }

    property var timeBar: QtObject {
        property color color: mainColor
        property color backgroundColor: "#FAFAFA"
        property color secondaryColor: Qt.darker(color, 1.5)

        property var font: StyleFont {
            color: "white"
            size: 0.8*style.font.text.size
            bold: true
        }

        property real gradientFactor: 1.25
    }

}
