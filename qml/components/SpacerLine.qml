import QtQuick 2.5
import "../style"

Rectangle {
    id: line
    property bool horizontal: false
    property int thickness: 1

    implicitWidth: horizontal ? thickness : 1
    implicitHeight: horizontal ? 1 : thickness
}
