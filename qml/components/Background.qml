import QtQuick 2.5
import "../"

Rectangle {
    color: Style.background.color

    Image {
        anchors.fill: parent

        source: Style.background.image
    }

    Image {
        anchors {
            top: parent.top
            topMargin: -0.2*height
            right: parent.right
            rightMargin: -0.2*width
        }

        width: 0.5*parent.width

        source: Style.decorative.image

        fillMode: Image.PreserveAspectFit
    }
}
