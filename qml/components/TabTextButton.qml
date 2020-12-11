import QtQuick 2.11
import QtQuick.Controls 2.4
import "../style"
import "../components"

TabButton {
    id: button

    property var styleFont: Style.font.textButton
    property string tooltip: text

    hoverEnabled: true
    ToolTip.visible: hovered
    ToolTip.delay: Style.tooltip.delay
    ToolTip.timeout: Style.tooltip.timeout
    ToolTip.text: tooltip

    background: Rectangle {
        opacity: button.pressed ? 0.8 : 1

        color: "transparent"
        border.color: button.styleFont.color
        border.width: 1
        radius: button.styleFont.size/5
    }

    contentItem: CustomLabel {
        fontStyle: button.styleFont

        opacity: button.pressed ? 0.8 : 1
        text: button.text
        horizontalAlignment: Text.AlignHCenter
    }
}
