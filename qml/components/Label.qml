import QtQuick 2.0
import "../style"

Text {
    property var fontStyle: Style.font.text

    color: fontStyle.color

    font.family: fontStyle.family
    font.pixelSize: fontStyle.size
    font.bold: fontStyle.bold
    font.capitalization: fontStyle.capitalization
}
