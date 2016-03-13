import QtQuick 2.5
import "../style"

Rectangle {
    color: Style.background.color

    Image {
        anchors.fill: parent

        source: Style.background.image
    }

    Image {
        anchors {
            top: parent.top
            topMargin: -0.4*height
            right: parent.right
        }

        height: parent.height

        source: Style.decorative.image

        fillMode: Image.PreserveAspectFit

        opacity: Style.background.opacity
    }
}
