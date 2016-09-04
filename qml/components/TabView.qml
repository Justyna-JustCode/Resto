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
import "../style"

TabView {
    property int tabsHeight

    style: TabViewStyle {
        tabsAlignment: Qt.AlignHCenter

        frame: Rectangle {
            border.width: Style.tabView.borderWidth
            border.color: Style.tabView.borderColor

            color: "transparent"
        }
        frameOverlap: Style.tabView.borderWidth

        tab: TextButton {
            text: styleData.title
            styleFont: styleData.selected ? Style.tabView.activeFont : Style.tabView.inactiveFont

            onClicked: {
                control.currentIndex = styleData.index
            }
            onHeightChanged: {
                control.tabsHeight = height;
            }
        }
    }
}
