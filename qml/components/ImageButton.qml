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
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "../style"
import "../components"

TextButton {
    id: button

    styleFont: Style.font.imageButton
    property string type

    QtObject {
        id: d
        property string path: "qrc:/resources/images/"
        property string extension: ".png"
    }


    background: Rectangle {
        visible: button.text.length
        opacity: button.pressed ? 0.8 : 1

        color: "transparent"
        border.color: button.styleFont.color
        border.width: 1
        radius: button.styleFont.size/5
    }

    contentItem: RowLayout {
        opacity: button.pressed || !button.enabled ? 0.8 : 1

        Image {
            id: image
            Layout.preferredHeight: button.styleFont.size * 1.5
            Layout.preferredWidth: (sourceSize.width / sourceSize.height) * Layout.preferredHeight

            source: d.path + type + d.extension
        }
        CustomLabel {
            id: text
            Layout.alignment: Qt.AlignVCenter

            fontStyle: button.styleFont

            text: button.text
        }
    }
}
