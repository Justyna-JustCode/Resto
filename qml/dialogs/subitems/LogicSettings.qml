import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../../components"
import "../../style"

SettingsPage {
    Component.onCompleted: {
        // set defaults
        autoStartSwitch.checked = controller.settings.autoStart
    }

    function save() {   // save current state
    }

    FormElement {
        labelText: qsTr("Auto start:")

        Switch {
            id: autoStartSwitch
            Layout.alignment: Qt.AlignRight
        }
    }

    Spacer {}

    Label {
        fontStyle: Style.font.formHeader
        text: qsTr("Times")
    }

    FormElement {
        labelText: qsTr("Break duration:")
    }
    FormElement {
        labelText: qsTr("Break interval:")
    }
    FormElement {
        labelText: qsTr("Work time:")
    }
}
