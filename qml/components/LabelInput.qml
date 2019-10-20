import QtQuick 2.12
import "../style"

TextInput {
    property var fontStyle

    font {
        family: fontStyle.family
        bold: fontStyle.bold
        italic: fontStyle.italic
        pixelSize: fontStyle.size
    }

    color: fontStyle.color
    selectionColor: color
    selectedTextColor: fontStyle.selectionColor
}
