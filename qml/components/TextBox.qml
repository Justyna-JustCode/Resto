/********************************************
**
** Copyright 2017 JustCode Justyna Kulinska
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
import "../style"

Rectangle {
    property alias text: textItem.text

    color: Style.textBox.backgroundColor
    border.width: Style.textBox.borderWidth
    border.color: Style.textBox.borderColor

    implicitWidth: textItem.implicitWidth + textItem.anchors.leftMargin + textItem.anchors.rightMargin
    implicitHeight: textItem.implicitHeight + textItem.anchors.topMargin + textItem.anchors.bottomMargin

    Label {
        id: textItem
        anchors {
            fill: parent
            margins: Style.font.smallerText.size
        }

        fontStyle: Style.font.smallerText
        textFormat: Text.RichText
    }
}
