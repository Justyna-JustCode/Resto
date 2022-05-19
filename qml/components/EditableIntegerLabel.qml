import QtQuick 2.12

import "./"
import "helpers"

Item {
    id: rootItem
    property alias fontStyle: displayLabel.fontStyle
    property alias editMode: editMode

    property alias editNumber: editSpinBox.value
    property alias minNumber: editSpinBox.from
    property alias maxNumber: editSpinBox.to

    property int number

    implicitWidth: Math.max(editSpinBox.implicitWidth, displayLabel.implicitWidth)
    implicitHeight: Math.max(editSpinBox.implicitHeight, displayLabel.implicitHeight)

    ValueEditMode {
        id: editMode

        focusItem: editSpinBox

        onRevertChanges: editSpinBox.value = rootItem.number
    }

    CustomLabel {
        id: displayLabel

        anchors.fill: parent
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        visible: !editMode.activeEdit
        text: rootItem.number
    }

    CustomSpinBox {
        id: editSpinBox

        anchors.fill: parent
        layer.enabled: true

        visible: editMode.activeEdit
        value: rootItem.number

        from: 1

        Binding {
            target: editSpinBox
            property: "value"
            value: rootItem.number
        }
    }
}
