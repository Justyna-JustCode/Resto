import QtQuick 2.7

Item {
    property bool horizontal: false
    property int size

    width: horizontal ? size : undefined
    height: horizontal ? undefined : size
}
