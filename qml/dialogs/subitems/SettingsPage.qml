import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../../components"
import "../../style"

ColumnLayout {
    default property alias content: layout.data

    function save() {}
    function discard() {}

    ColumnLayout {
        id: layout

        anchors {
            fill: parent
            margins: Style.smallMargins
        }
    }
    Spacer {
        Layout.fillHeight: true
    }
}
