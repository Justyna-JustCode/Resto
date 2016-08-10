import QtQuick 2.0

Item {
    property bool fillWidth: false
    property bool fillHeight: false

    property int preferredWidth: childrenRect.width
    property int preferredHeight: childrenRect.height

    property int alignment: 0
}
