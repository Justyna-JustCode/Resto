/********************************************
**
** Copyright 2016 Justyna JustCode
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
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Resto.Types 1.0
import "components"
import "dialogs"
import "style"

Item {
    Keys.onSpacePressed: {
        if (controller.state == Controller.Working) {
            controller.pause()
        } else {
            controller.start()
        }
    }

    Background {
        Decorative {}
    }

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: Style.bigMargins
        spacing: 0

        RowLayout {
            ImageButton {
                type: "play"
                tooltip: qsTr("Play")

                visible: controller.state !== Controller.Working

                onClicked: {
                    controller.start()
                }
            }
            ImageButton {
                type: "break"
                tooltip: qsTr("Break\nHold right button to skip")

                visible: controller.state === Controller.Working

                onClicked: {
                    controller.startBreak()
                    dialogsManager.showBreakDialog();
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onPressAndHold: {
                        controller.skipBreak();
                    }
                }
            }
            ImageButton {
                type: "pause"
                tooltip: qsTr("Pause")

                visible: controller.state === Controller.Working

                onClicked: {
                    controller.pause()
                }
            }
            ImageButton {
                type: "stop"
                tooltip: qsTr("Stop")

                visible: controller.state === Controller.Working

                onClicked: {
                    controller.stop()
                }
            }
        }

        // current interval
        RowLayout {
            visible: controller.settings.cyclesMode

            spacing: Style.smallSpacing

            CustomLabel {
                text: qsTr("Current interval:")
            }
            EditableIntegerLabel {
                id: currentCycleIntervalLabel
                number: controller.cycles.currentInterval
                maxNumber: controller.settings.cycleIntervals

                editMode.onConfirmChanges: controller.cycles.currentInterval = editNumber
            }

            ImageButton {
                enabled: !currentCycleIntervalLabel.editMode.activeEdit &&
                         controller.state !== Controller.Off

                styleFont: Style.font.imageButtonSmallest
                type: "edit"
                tooltip: qsTr("Edit current interval")

                onClicked:
                {
                    currentCycleIntervalLabel.editMode.edit()
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true

            columns: 3

            columnSpacing: Style.spacing
            rowSpacing: Style.smallSpacing

            // next break
            CustomLabel {
                text: qsTr("Next break:")
            }

            TimeProgressBar {
                id: nextBreakTimeProgressBar
                Layout.fillWidth: true

                maxValue: controller.settings.breakInterval
                value: controller.timer.elapsedBreakInterval

                onTimeEdited:
                {
                    var timeDiff = newValue - controller.timer.elapsedBreakInterval
                    controller.timer.elapsedBreakInterval = newValue
                    controller.timer.elapsedWorkTime += timeDiff
                }
            }

            ImageButton {
                enabled: !nextBreakTimeProgressBar.timeEditMode &&
                         controller.state !== Controller.Off
                visible: nextBreakTimeProgressBar.editMode.enabled
                styleFont: Style.font.imageButtonSmallest
                type: "edit"
                tooltip: qsTr("Edit next break")

                onClicked:
                {
                    nextBreakTimeProgressBar.editMode.edit()
                }
            }

            // work time
            CustomLabel {
                text: qsTr("Work time:")
            }

            TimeProgressBar {
                id: workTimeProgressBar
                Layout.fillWidth: true

                maxValue: controller.settings.workTime
                value: controller.timer.elapsedWorkTime

                onTimeEdited:
                {
                    var timeDiff = newValue - controller.timer.elapsedWorkTime
                    controller.timer.elapsedWorkTime = newValue
                }
            }

            ImageButton {
                enabled: !workTimeProgressBar.timeEditMode &&
                         controller.state !== Controller.Off
                visible: workTimeProgressBar.editMode.enabled
                styleFont: Style.font.imageButtonSmallest
                type: "edit"
                tooltip: qsTr("Edit work time")

                onClicked:
                {
                    workTimeProgressBar.editMode.edit()
                }
            }
        }
    }

    // small buttons
    // left
    RowLayout {
        anchors {
            left: parent.left
            bottom: parent.bottom
        }

        ImageButton {
            styleFont: Style.font.imageButtonSmallest
            type: "help"
            tooltip: qsTr("Here you find your help")

            onClicked: controller.openHelp()
        }
    }

    // right
    RowLayout {
        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        ImageButton {
            styleFont: Style.font.imageButtonSmall
            type: "settings"
            tooltip: qsTr("Change settings")

            onClicked: dialogsManager.showSettingsDialog()
        }
        ImageButton {
            styleFont: Style.font.imageButtonSmall
            type: "about"
            tooltip: qsTr("About resto")

            onClicked: dialogsManager.showAboutDialog()
        }
    }
}

