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

SettingsPage {

    QtObject {
        id: d

        property color applicationColor
    }

    Component.onCompleted: {
        // save state before change
        d.applicationColor = Style.mainColor
    }

    function save() {   // save current state
        controller.settings.applicationColor = Style.mainColor
    }
    function discard() {    // restore previous state
        Style.mainColor = d.applicationColor
    }

    FormElement {
        labelText: qsTr("Color:")
        ColorPicker {
            id: picker

            currentColor: Style.mainColor
            availableColors: controller.settings.availableColors

            onCurrentColorChanged: {
                Style.mainColor = currentColor
            }
        }
    }
}
