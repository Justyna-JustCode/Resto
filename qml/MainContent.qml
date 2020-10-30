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
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import Resto.Types 1.0
import "components"
import "dialogs"
import "style"

Item {
    Background {
        Decorative {}
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 30
        spacing: 0

        RowLayout {
            ImageButton {
                type: "play"
                tooltip: qsTr("Play")

                visible: controller.state != Controller.Working

                onClicked: {
                    controller.start()
                }
            }
            ImageButton {
                type: "break"
                tooltip: qsTr("Break\nHold right button to skip")

                visible: controller.state == Controller.Working

                onClicked: {
                    controller.startBreak()
                    dialogsManager.showBreakDialog();
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onPressAndHold: {
                        controller.startWork();
                    }
                }
            }
            ImageButton {
                type: "pause"
                tooltip: qsTr("Pause")

                visible: controller.state == Controller.Working

                onClicked: {
                    controller.pause()
                }
            }
            ImageButton {
                type: "stop"
                tooltip: qsTr("Stop")

                visible: controller.state == Controller.Working

                onClicked: {
                    controller.stop()
                }
            }
        }
        GridLayout {
            Layout.fillWidth: true
            columns: 3

            // current iteration
            Label {
                text: qsTr("Current iteration:")
                visible: controller.settings.cyclesMode
            }
            Label {
                text: controller.cycles.currentIteration
                visible: controller.settings.cyclesMode
            }

            ImageButton {
                //enabled: !workTimeProgressBar.timeEditMode
                //visible: workTimeProgressBar.enableEditMode
                visible: controller.settings.cyclesMode
                styleFont: Style.font.imageButtonSmallest
                type: "edit"
                tooltip: qsTr("Edit current iteration")

                onClicked:
                {
                    // TODO
                }
            }

            // next break
            Label {
                text: qsTr("Next break:")
            }

            TimeProgressBar {
                id: nextBreakTimeProgressBar
                Layout.fillWidth: true

                maxValue: controller.settings.breakInterval
                value: controller.timer.elapsedBreakInterval

                onTimeValueChanged:
                {
                    var timeDiff = newValue - controller.timer.elapsedWorkPeriod
                    controller.timer.elapsedWorkPeriod = newValue
                    controller.timer.elapsedWorkTime += timeDiff
                }
            }

            ImageButton {
                enabled: !nextBreakTimeProgressBar.timeEditMode
                visible: nextBreakTimeProgressBar.enableEditMode
                styleFont: Style.font.imageButtonSmallest
                type: "edit"
                tooltip: qsTr("Edit next break")

                onClicked:
                {
                    nextBreakTimeProgressBar.timeEditMode = true
                }
            }

            // work time
            Label {
                text: qsTr("Work time:")
            }

            TimeProgressBar {
                id: workTimeProgressBar
                Layout.fillWidth: true
                maxValue: controller.settings.workTime
                value: controller.timer.elapsedWorkTime

                onTimeValueChanged:
                {
                    var timeDiff = newValue - controller.timer.elapsedWorkTime
                    controller.timer.elapsedWorkTime = newValue
                }
            }

            ImageButton {
                enabled: !workTimeProgressBar.timeEditMode
                visible: workTimeProgressBar.enableEditMode
                styleFont: Style.font.imageButtonSmallest
                type: "edit"
                tooltip: qsTr("Edit work time")

                onClicked:
                {
                    workTimeProgressBar.timeEditMode = true
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

