import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../style"

GridLayout {
    property alias labelText: label.text

    columns: 2
    rows: 2

    Label {
        id: label
        fontStyle: Style.font.formLabel
    }
}
