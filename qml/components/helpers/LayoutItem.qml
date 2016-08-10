import QtQuick 2.5

Item {
    property bool fillWidth: false
    property bool fillHeight: false

    property int preferredWidth: childrenRect.width
    property int preferredHeight: childrenRect.height

    property int alignment: 0
}
