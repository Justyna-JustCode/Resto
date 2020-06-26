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
import QtQuick.Controls 2.4
import QtQml.Models 2.2
import "../components"

CustomDialog {
    signal endBreak();

    onShowing: {
        endButton.text = qsTr("Abort");
    }

    title: controller.isCycleBreak ? qsTr("Take a long break!")
                                   : qsTr("Time for a break!")
    description: qsTr("Break time:")

    image.source: "qrc:/resources/images/break.png"
    image.scale: 0.85
    image.data: PropertyAnimation {
        loops: Animation.Infinite
        running: true

        target: image
        property: "rotation"
        from: 0; to: 360;
        duration: 3000
        easing.type: Easing.InBounce
    }

    buttons: ObjectModel {
        TextButton {
            id: endButton

            onClicked: {
                close();
                endBreak();
            }
        }
    }

    additionalContent.fillWidth: true
    additionalContent.data: TimeProgressBar {
        width: parent.width
        maxValue: controller.isCycleBreak ? controller.settings.cycleBreakDuration
                                          : controller.settings.breakDuration
        value: controller.timer.elapsedBreakDuration
    }

    Connections {
        target: controller

        onBreakEndRequest: {
            endButton.text = qsTr("Ok");
        }
    }
}

