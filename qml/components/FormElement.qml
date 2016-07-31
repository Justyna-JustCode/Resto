import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../style"

GridLayout {
    property alias labelText: label.text
    property bool strechHorizontally: true
    property bool strechVertically: false

    Label {
        id: label
        fontStyle: Style.font.formLabel
    }
    Spacer {
        Layout.fillWidth: strechHorizontally &&
                          (flow == GridLayout.LeftToRight)
        Layout.fillHeight: strechVertically &&
                          (flow == GridLayout.TopToBottom)

        size: 1
        visible: Layout.fillWidth || Layout.fillHeight
    }
}
