import QtQuick 2.7
import "../style"

Rectangle {
    anchors.fill: parent
    color: Style.background.color

    Image {
        anchors.fill: parent
        anchors.margins: parent.border.width

        source: Style.background.image
    }
}
