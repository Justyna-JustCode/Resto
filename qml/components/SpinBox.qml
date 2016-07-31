import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../components"
import "../components/helpers"
import "../style"

SpinBox {
    style: SpinBoxStyle {
        property var fontStyle: Style.spinBox.font
        property int maxCharCount: prefix.length + suffix.length + Math.ceil(Math.log(control.maximumValue) / Math.log(10))

        FontMetrics {
            id: fontMetrics
            font: font
        }

        font {
            family: fontStyle.family
            bold: fontStyle.bold
            italic: fontStyle.italic
            pixelSize: fontStyle.size
        }

        textColor: fontStyle.color
        selectionColor: textColor
        selectedTextColor: Style.spinBox.selectedTextColor

        background: Item {
            implicitHeight: fontStyle.size * 1.5
            implicitWidth: (maxCharCount + 1) * fontMetrics.maximumCharacterWidth + Style.spacing/2
        }

        // increment component
        incrementControl: SpinBoxControl {
            increment: true
        }
        decrementControl: SpinBoxControl {
            increment: false
        }
    }
}
