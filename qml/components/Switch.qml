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
import QtQuick.Controls.Styles 1.4
import "../style"
import "../components"

Switch {
    property string onStateName: qsTr("On")
    property string offStateName: qsTr("Off")

    style: SwitchStyle {
        handle: Rectangle {
            id: handle
            implicitWidth: control.width*0.6
            implicitHeight: Style.switchControl.font.size*1.5

            color: Style.switchControl.handleColor
            border.width: 2
            border.color: text.fontStyle.color

            radius: Style.switchControl.font.size/2

            Label {
                id: text
                anchors {
                    centerIn: parent
                }
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter

                fontStyle: Style.switchControl.font

                text: control.checked ? control.onStateName : control.offStateName
            }
        }
        groove: Rectangle {
            implicitWidth: 90
            implicitHeight: Style.switchControl.font.size*1.5

            border.width: Style.switchControl.borderWidth
            border.color: Style.switchControl.handleColor

            radius: Style.switchControl.font.size/2

            color: control.pressed
                   ? Qt.darker(Style.switchControl.backgroundColor, 1.1)
                   : Style.switchControl.backgroundColor
        }
    }
}
