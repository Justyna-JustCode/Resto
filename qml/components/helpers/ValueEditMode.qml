import QtQuick 2.12

Item {
    id: valueEditMode
    property bool activeEdit: false
    property Item focusItem: null

    // defines if editing is finished automatically for accepting
    property bool autoConfirm: true

    // defines if editing is finished automatically for declining
    property bool autoDecline: true

    signal confirmChanges()
    signal revertChanges()

    function edit() {
        activeEdit = true
    }

    function accept() {
        confirmChanges()

        if (autoConfirm) {
            activeEdit = false
        }
    }

    function decline() {
        revertChanges()

        if (autoDecline) {
            activeEdit = false
        }
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
