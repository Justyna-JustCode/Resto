pragma Singleton
import QtQuick 2.5
import "."
import "helpers"

QtObject {
    id: style

    property color mainColor: ColorPallete.mainColor

    readonly property int margins: 20
    readonly property int smallMargins: 10
    readonly property int spacing: 10

    readonly property var background: QtObject {
        readonly property string color: ColorPallete.secondaryLightColor
        readonly property string image: "qrc:/resources/images/background.png"
        readonly property real opacity: 0.8
        readonly property color borderColor: ColorPallete.secondaryDarkColor
        readonly property int borderWidth: 3
    }
    readonly property var decorative: QtObject {
        readonly property string image: "qrc:/resources/images/pattern.png"
        readonly property string imageColor: "qrc:/resources/images/pattern-color.png"
        readonly property color color: ColorPallete.mainColor
    }

    readonly property var font: QtObject {
        readonly property var text: StyleFont {}
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
            color: ColorPallete.mainColor
        }
        readonly property var formLabel: StyleFont {
            capitalization: Font.SmallCaps
        }
    }

    readonly property var timeBar: QtObject {
        readonly property color color: ColorPallete.mainColor
        readonly property color backgroundColor: ColorPallete.secondaryLightColor
        readonly property color secondaryColor: Qt.darker(color, 1.5)

        readonly property var font: StyleFont {
            color: ColorPallete.secondaryLightColor
            size: 0.8*style.font.text.size
            bold: true
        }

        readonly property real gradientFactor: 1.25
    }

    readonly property var tabView: QtObject {
        readonly property color borderColor: ColorPallete.mainColor
        readonly property int borderWidth: 1

        readonly property var activeFont: StyleFont {
            bold: true
            color: ColorPallete.mainColor
        }
        readonly property var inactiveFont: StyleFont {
            bold: true
            color: ColorPallete.secondaryDarkColor
        }
    }
    readonly property var colorPicker: QtObject {
        readonly property color activeColor: ColorPallete.secondaryDarkColor
        readonly property color inactiveColor: ColorPallete.secondaryLightColor

        readonly property int activeBorderWidth: 2
        readonly property int inactiveBorderWidth: 1
        readonly property int itemSize: 20
    }
}
