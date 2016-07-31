import QtQuick 2.5
import QtGraphicalEffects 1.0
import "../style"

Image {
    anchors {
        top: parent.top
        topMargin: -0.4*height
        right: parent.right
    }
    height: parent.height

    source: Style.decorative.image

    horizontalAlignment: Qt.AlignRight
    fillMode: Image.PreserveAspectFit

    opacity: Style.background.opacity

    Image {
        anchors.fill: parent

        source: Style.decorative.imageColor

        horizontalAlignment: Qt.AlignRight
        fillMode: Image.PreserveAspectFit

        ColorOverlay {
            anchors.fill: parent
            source: parent

            color: Style.decorative.color
        }
    }
}
