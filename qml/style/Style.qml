pragma Singleton
import QtQuick 2.7
import "."

QtObject {
    id: style

    readonly property color mainColor: "#19886f"

    readonly property int margins: 20
    readonly property int spacing: 10

    readonly property var background: QtObject {
        readonly property string color: "white"
        readonly property string image: "qrc:/resources/images/background.png"
        readonly property real opacity: 0.8
        readonly property color borderColor: "black"
        readonly property int borderWidth: 3
    }
    readonly property var decorative: QtObject {
        readonly property string image: "qrc:/resources/images/pattern.png"
        readonly property string imageColor: "qrc:/resources/images/pattern-color.png"
    }

    readonly property var font: QtObject {
        readonly property var text: StyleFont { linkColor: mainColor }
        readonly property var textButton: StyleFont {
            bold: true
            capitalization: Font.SmallCaps
        }
        readonly property var imageButton: StyleFont {
            size: style.font.text.size*1.3
            capitalization: Font.SmallCaps
        }
        readonly property var imageButtonSmall: StyleFont {
            size: style.font.text.size*0.7
            capitalization: Font.SmallCaps
        }
        readonly property var title: StyleFont {
            size: style.font.text.size*1.2
            bold: true
        }
    }

    readonly property var timeBar: QtObject {
        readonly property color color: mainColor
        readonly property color backgroundColor: "#FAFAFA"
        readonly property color secondaryColor: Qt.darker(color, 1.5)

        readonly property var font: StyleFont {
            color: "white"
            size: 0.8*style.font.text.size
            bold: true
        }

        readonly property real gradientFactor: 1.25
    }

}
