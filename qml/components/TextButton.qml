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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "../style"
import "../components"

Button {
    id: button

    property var styleFont: Style.font.textButton
    tooltip: text

    style: ButtonStyle {
        background: Rectangle {
            opacity: control.pressed ? 0.8 : 1

            color: "transparent"
            border.color: control.styleFont.color
            border.width: 1
            radius: control.styleFont.size/5
        }

        label: GridLayout {
            opacity: control.pressed ? 0.8 : 1

            Label {
                id: text
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: control.styleFont.size/2
                Layout.rightMargin: control.styleFont.size/2
                Layout.topMargin: control.styleFont.size/4
                Layout.bottomMargin: control.styleFont.size/4

                fontStyle: control.styleFont

                text: control.text
            }
        }
    }
}
