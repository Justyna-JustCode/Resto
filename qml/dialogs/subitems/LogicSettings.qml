/********************************************
**
** Copyright 2016 JustCode Justyna Kulinska
**
** This file is part of Resto.
**
** Resto is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** any later version.
**
** Resto is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Resto; if not, write to the Free Software
** Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
**
********************************************/

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

        autoHideSwitch.checked = controller.settings.autoHide
        hideOnCloseSwitch.checked = controller.settings.hideOnClose
    }

    function save() {   // save current state
        controller.settings.autoStart = autoStartSwitch.checked

        controller.settings.breakDuration = breakDurationSelector.time
        controller.settings.breakInterval = breakIntervalSelector.time
        controller.settings.postponeTime = postponeTimeSelector.time
        controller.settings.workTime = workTimeSelector.time

        controller.settings.autoHide = autoHideSwitch.checked
        controller.settings.hideOnClose = hideOnCloseSwitch.checked
    }

    FormElement {
        labelText: qsTr("Auto start:")

        Switch {
            id: autoStartSwitch
            Layout.alignment: Qt.AlignRight
        }
    }

    Spacer {}

    // TIMES SETTINGS
    Label {
        fontStyle: Style.font.formHeader
        text: qsTr("Times")
    }

    FormElement {
        labelText: qsTr("Break duration:")

        TimeSelector {
            id: breakDurationSelector

            showSeconds: false
            minTime: 60
        }
    }
    FormElement {
        labelText: qsTr("Break interval:")

        TimeSelector {
            id: breakIntervalSelector

            showSeconds: false
            minTime: 60
        }
    }
    FormElement {
        labelText: qsTr("Postpone time:")

        TimeSelector {
            id: postponeTimeSelector

            showSeconds: false
            minTime: 60
        }
    }
    FormElement {
        labelText: qsTr("Work time:")

        TimeSelector {
            id: workTimeSelector

            showSeconds: false
            minTime: 60
        }
    }

    Spacer {}

    // TRAY SETTINGS
    Label {
        visible: controller.settings.trayAvailable

        fontStyle: Style.font.formHeader
        text: qsTr("System tray")
    }

    FormElement {
        visible: controller.settings.trayAvailable

        labelText: qsTr("Auto hide:")

        Switch {
            id: autoHideSwitch
            Layout.alignment: Qt.AlignRight
        }
    }

    FormElement {
        visible: controller.settings.trayAvailable

        labelText: qsTr("Hide on close:")

        Switch {
            id: hideOnCloseSwitch
            Layout.alignment: Qt.AlignRight
        }
    }
}
