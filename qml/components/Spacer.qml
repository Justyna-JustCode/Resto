import QtQuick 2.5

Item {
    property bool horizontal: false
    property int size

    width: horizontal ? size : undefined
    height: horizontal ? undefined : size
}
