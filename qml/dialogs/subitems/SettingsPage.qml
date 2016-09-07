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
import "../../components"
import "../../style"

ColumnLayout {
    default property alias content: layout.data

    function save() {}
    function discard() {}

    /* this additional item is to support Qt 5.7
       for some reason it doesn't work well without it */
    Item {
        Layout.margins: Style.smallMargins
        implicitHeight: layout.implicitHeight
        implicitWidth: layout.implicitWidth

        ColumnLayout {
            id: layout

            anchors.centerIn: parent
        }
    }

    Spacer {
        Layout.fillHeight: true
    }
}
