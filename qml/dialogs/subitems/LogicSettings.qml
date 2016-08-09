import QtQuick 2.5
import QtQuick.Layouts 1.1
import "../../components"
import "../../style"

SettingsPage {
    Component.onCompleted: {
        // set defaults
        autoStartSwitch.checked = controller.settings.autoStart
        breakDurationSelector.time = controller.settings.breakDuration
        breakIntervalSelector.time = controller.settings.breakInterval
        postponeTimeSelector.time = controller.settings.postponeTime
        workTimeSelector.time = controller.settings.workTime
    }

    function save() {   // save current state
        controller.settings.autoStart = autoStartSwitch.checked
        controller.settings.breakDuration = breakDurationSelector.time
        controller.settings.breakInterval = breakIntervalSelector.time
        controller.settings.postponeTime = postponeTimeSelector.time
        controller.settings.workTime = workTimeSelector.time
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

        TimeSelector {
            id: breakDurationSelector
            showSeconds: false
        }
    }
    FormElement {
        labelText: qsTr("Break interval:")

        TimeSelector {
            id: breakIntervalSelector
            showSeconds: false
        }
    }
    FormElement {
        labelText: qsTr("Postpone time:")

        TimeSelector {
            id: postponeTimeSelector
            showSeconds: false
        }
    }
    FormElement {
        labelText: qsTr("Work time:")

        TimeSelector {
            id: workTimeSelector
            showSeconds: false
        }
    }
}
