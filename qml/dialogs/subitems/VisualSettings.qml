import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../../components"
import "../../style"

SettingsPage {
    property color applicationColor

    Component.onCompleted: {
        // save state before change
        applicationColor = Style.mainColor
    }

    function save() {   // save current state
        controller.settings.applicationColor = Style.mainColor
        // FIXME: remove this when dialogs would be created dynamically as it will not be needed anymore
        applicationColor = Style.mainColor
        picker.currentColor = applicationColor
        // ----------------------------------------------------------------------------------------------
    }
    function discard() {    // restore previous state
        Style.mainColor = applicationColor
        // FIXME: remove this when dialogs would be created dynamically as it will not be needed anymore
        applicationColor = Style.mainColor
        picker.currentColor = applicationColor
        // ----------------------------------------------------------------------------------------------
    }

    FormElement {
        labelText: qsTr("Color:")
        flow: GridLayout.TopToBottom

        ColorPicker {
            id: picker

            currentColor: Style.mainColor
            availableColors: controller.settings.availableColors

            onCurrentColorChanged: {
                console.log(currentColor, controller.settings.availableColors)
                Style.mainColor = currentColor
            }
        }
    }
}
