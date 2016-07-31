import QtQuick 2.0
import "helpers"

QtObject {
    property color color: ColorPallete.secondaryDarkColor
    property color linkColor: ColorPallete.mainColor

    property int size: 20
    property string family: loader.name
    property bool bold: false
    property bool italic: false
    property int capitalization: Font.MixedCase

    property var loader: FontLoader {
        id: loader
        source: "qrc:/resources/fonts/font" +
                (bold ? "-bold" : "") +
                (italic ? "-italic" : "") +
                ".ttf"
    }
}
