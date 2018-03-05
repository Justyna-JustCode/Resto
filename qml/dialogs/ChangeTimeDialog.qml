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
import QtQuick.Controls 1.4
import QtQml.Models 2.2
import "../components"

CustomDialog {

    signal addTime(int time)
    signal removeTime(int time)

    onShowing: {
        addButton.text = qsTr("Add")
        removeButton.text = qsTr("Remove")
        cancelButton.text = qsTr("Cancel")
    }

    title: qsTr("Add time")

    image.source: "qrc:/change-time"
    image.preferredWidth: 20
    image.preferredHeight: 20
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
            id: addButton

            onClicked: {
                close();
                addTime(timerSpinbox.value)
            }
        }

        TextButton {
            id: removeButton

            onClicked: {
                close();
                removeTime(timerSpinbox.value)
            }
        }

        TextButton {
            id: cancelButton

            onClicked: {
                close();
            }
        }
    }

    additionalContent.fillWidth: false
    additionalContent.data: SpinBox {
        id: timerSpinbox

        maximumValue: 999
        minimumValue: 1
        suffix: "min"
    }
}

