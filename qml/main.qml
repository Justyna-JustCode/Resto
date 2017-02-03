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
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import Resto.Types 1.0
import "components"
import "dialogs"
import "style"

Window {
    visible: true

    function showBreakDialog() {
        dialogsManager.showBreakDialog()
    }
    function showSettingsDialog() {
        dialogsManager.showSettingsDialog()
    }
    function showAboutDialog() {
        dialogsManager.showAboutDialog()
    }

    // load and save main window position and size
    Component.onCompleted: {
        width = controller.settings.windowSize.width
        height = controller.settings.windowSize.height
        x = controller.settings.windowPosition.x >= 0 ?
                    controller.settings.windowPosition.x : (Screen.width - width)/2
        y = controller.settings.windowPosition.y >= 0 ?
                    controller.settings.windowPosition.y : (Screen.height - height)/2

        // check if update available
        controller.updater.checkUpdateAvailable();
    }

    onWidthChanged: {
        controller.settings.windowSize.width = width;
    }
    onHeightChanged: {
        controller.settings.windowSize.height = height;
    }

    onXChanged: {
        controller.settings.windowPosition.x = x;
    }
    onYChanged: {
        controller.settings.windowPosition.y = y;
    }
    // ----------------------------------------------

    Background {
        Decorative {}
    }

    // connections
    Connections {
        target: controller

        onBreakStartRequest: {
            dialogsManager.showBreakRequestDialog();
        }
        onWorkEndRequest: {
            dialogsManager.showEndWorkRequestDialog();
        }
    }
    Connections {
        property bool initialCheck: true

        target: controller.updater

        onCheckFinished: {
            if (controller.updater.updateAvailable) {
                dialogsManager.showUpdateInfoDialog();
            }

            if (initialCheck) {
                initialCheck = false;
            } else if (!controller.updater.updateAvailable) {
                dialogsManager.showNoUpdateDialog();
            }
        }
        onCheckError: {
            if (initialCheck) {
                initialCheck = false;
            } else {
                dialogsManager.showUpdateErrorDialog();
            }
        }
    }

    // dialogs
    DialogsManager {
        id: dialogsManager
    }

    // content
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
                tooltip: qsTr("Break")

                visible: controller.state == Controller.Working

                onClicked: {
                    controller.startBreak()
                    dialogsManager.showBreakDialog();
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
            columns: 2

            Label {
                text: qsTr("Next break:")
            }
            TimeProgressBar {
                Layout.fillWidth: true

                maxValue: controller.settings.breakInterval
                value: controller.timer.elapsedWorkPeriod
            }
            Label {
                text: qsTr("Work time:")
            }
            TimeProgressBar {
                Layout.fillWidth: true

                maxValue: controller.settings.workTime
                value: controller.timer.elapsedWorkTime
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

