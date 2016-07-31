pragma Singleton
import QtQuick 2.5
import "."

QtObject {
    id: style

    property color mainColor: controller.settings.applicationColor

    readonly property int margins: 20
    readonly property int smallMargins: 10
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
        readonly property var formLabel: StyleFont {
            capitalization: Font.SmallCaps
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

    readonly property var tabView: QtObject {
        readonly property color borderColor: mainColor
        readonly property int borderWidth: 1

        readonly property var activeFont: StyleFont {
            bold: true
            color: mainColor
        }
        readonly property var inactiveFont: StyleFont {
            bold: true
            color: "#1E1E1E"
        }
    }
    readonly property var colorPicker: QtObject {
        readonly property color activeColor: "black"
        readonly property color inactiveColor: "white"

        readonly property int activeBorderWidth: 2
        readonly property int inanctiveBorderWidth: 1
        readonly property int itemSize: 20
    }
}
