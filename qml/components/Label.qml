import QtQuick 2.0
import "../"

Text {
    property var fontStyle: Style.font

    color: Style.timeBar.fontColor

    font.family: fontStyle.family
    font.pixelSize: fontStyle.size
    font.bold: fontStyle.bold
}
