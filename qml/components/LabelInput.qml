import QtQuick 2.12
import "../style"
import "../utils"

TextInput {
    property var fontStyle

    font {
        family: fontStyle.family
        bold: fontStyle.bold
        italic: fontStyle.italic
        pixelSize: fontStyle.size
    }


    color: UiUtils.resolveControlColor(fontStyle.color, enabled)
    selectionColor: color
    selectedTextColor: fontStyle.selectionColor
}
