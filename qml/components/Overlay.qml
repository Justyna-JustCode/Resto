import QtQuick 2.0
import "../style"

Rectangle {
    anchors.fill: parent
    color: Style.overlay.color

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.AllButtons
        propagateComposedEvents: false
        preventStealing: true
    }
}
