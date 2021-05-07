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
import QtQuick.Controls 2.4
import "../style"
import "../components"

Button {
    id: button

    property var styleFont: Style.font.textButton
    property string tooltip: text

    hoverEnabled: true
    ToolTip.visible: hovered
    ToolTip.delay: Style.tooltip.delay
    ToolTip.timeout: Style.tooltip.timeout
    ToolTip.text: tooltip

    background: Rectangle {
        opacity: button.pressed ? 0.8 : 1

        color: "transparent"
        border.color: button.styleFont.color
        border.width: 1
        radius: button.styleFont.size/5
    }

    contentItem: CustomLabel {
        fontStyle: button.styleFont

        opacity: button.pressed ? 0.8 : 1
        text: button.text
    }
}
