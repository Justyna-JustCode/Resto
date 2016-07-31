import QtQuick 2.5
import "../style"

Item {
    property bool horizontal: false
    property int size: Style.spacing

    implicitWidth: horizontal ? size : 1
    implicitHeight: horizontal ? 1 : size
}
