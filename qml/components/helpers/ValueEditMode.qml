import QtQuick 2.12

Item {
    id: valueEditMode
    property bool activeEdit: false
    property Item focusItem: null

    signal confirmChanges()
    signal revertChanges()

    function edit() {
        activeEdit = true
    }

    function accept() {
        confirmChanges()
        activeEdit = false
    }

    function decline() {
        revertChanges()
        activeEdit = false
    }

    onFocusItemChanged: {
        focusItem.Keys.forwardTo.push(valueEditMode)
    }

    onActiveEditChanged: {
        if (activeEdit && focusItem) {
            focusItem.forceActiveFocus()
        }
    }

    Keys.onReturnPressed:
    {
        accept()
    }

    Keys.onEnterPressed:
    {
        accept()
    }

    Keys.onEscapePressed:
    {
        decline()
    }

    Connections {
        target: focusItem

        onActiveFocusChanged:
        {
            if (!focusItem.activeFocus)
            {
                decline()
            }
        }
    }
}
