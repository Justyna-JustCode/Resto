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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "../style"
import "../utils"
import "../components"

Switch {
    id: switchControl
    property string onStateName: qsTr("On")
    property string offStateName: qsTr("Off")

    QtObject {
        id: d

        property color resolvedHandleColor: UiUtils.resolveControlColor(
                                                Style.switchControl.handleColor, switchControl.enabled)
    }

    implicitWidth: 90
    implicitHeight: Style.switchControl.font.size * 1.5

    indicator: Rectangle {
        width: switchControl.width * 0.6
        height: switchControl.height

        x: switchControl.visualPosition * (switchControl.width - width)

        color: d.resolvedHandleColor
        border.width: 2
        border.color: contentItem.fontStyle.color

        radius: Style.switchControl.font.size / 2
    }
    background: Rectangle {
        border.width: Style.switchControl.borderWidth
        border.color: d.resolvedHandleColor

        radius: Style.switchControl.font.size / 2

        color: switchControl.pressed
               ? Qt.darker(Style.switchControl.backgroundColor, 1.1)
               : Style.switchControl.backgroundColor
    }
    contentItem: CustomLabel {
        anchors.fill: indicator
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        fontStyle: Style.switchControl.font

        text: switchControl.checked ? switchControl.onStateName : switchControl.offStateName
    }
}
