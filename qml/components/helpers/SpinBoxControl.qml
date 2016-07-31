import QtQuick 2.5
import QtGraphicalEffects 1.0
import "../../style"

Image {
    property bool increment: true

    scale: 0.7
    fillMode: Image.PreserveAspectFit

    source: increment
            ? Style.spinBox.incrementImage
            : Style.spinBox.decrementImage

    ColorOverlay {
        anchors.fill: parent
        source: parent
        color: Style.spinBox.font.color
    }

}
