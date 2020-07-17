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

import QtQuick 2.12
import QtQuick.Layouts 1.3
import "../../components"
import "../../style"

SettingsPage {
    Component.onCompleted: {
        // set defaults
        breakDurationSelector.time = controller.settings.breakDuration
        breakIntervalSelector.time = controller.settings.breakInterval
        includeBreaksSwitch.checked = controller.settings.includeBreaks

        cyclesModeSwitch.checked = controller.settings.cyclesMode
        cycleBreakDurationSelector.time = controller.settings.cycleBreakDuration
        cycleIterationsSpin.value = controller.settings.cycleIterations

        postponeTimeSelector.time = controller.settings.postponeTime
        workTimeSelector.time = controller.settings.workTime
    }

    function save() {   // save current state
        controller.settings.breakDuration = breakDurationSelector.time
        controller.settings.breakInterval = breakIntervalSelector.time
        controller.settings.includeBreaks = includeBreaksSwitch.checked

        controller.settings.cyclesMode = cyclesModeSwitch.checked
        controller.settings.cycleBreakDuration = cycleBreakDurationSelector.time
        controller.settings.cycleIterations = cycleIterationsSpin.value

        controller.settings.postponeTime = postponeTimeSelector.time
        controller.settings.workTime = workTimeSelector.time
    }

    // BREAKS SETTINGS
    Label {
        fontStyle: Style.font.formHeader
        text: qsTr("Breaks")
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
        labelText: qsTr("Include breaks:")

        CustomSwitch {
            id: includeBreaksSwitch
            Layout.alignment: Qt.AlignRight
        }
    }

    Spacer {}

    // CYCLES SETTINGS
    FormElement {
        labelFontStyle: Style.font.formHeader
        labelText: qsTr("Cycles")

        CustomSwitch {
            id: cyclesModeSwitch
            Layout.alignment: Qt.AlignRight
        }
    }

    FormElement {
        enabled: cyclesModeSwitch.checked

        labelText: qsTr("Cycle break duration:")

        TimeSelector {
            id: cycleBreakDurationSelector

            showSeconds: false
            minTime: 60
        }
    }
    FormElement {
        enabled: cyclesModeSwitch.checked

        labelText: qsTr("Cycle iterations:")

        CustomSpinBox {
            id: cycleIterationsSpin

            from: 1
            to: 10
            maxCharCount: 2
        }
    }

    Spacer {}

    // GENERAL SETTINGS
    Label {
        visible: controller.settings.trayAvailable

        fontStyle: Style.font.formHeader
        text: qsTr("General")
    }

    FormElement {
        labelText: qsTr("Work time:")

        TimeSelector {
            id: workTimeSelector

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
}
