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
import "../components"
import "../components/helpers"
import "../style"

SpinBox {
    style: SpinBoxStyle {
        property var fontStyle: Style.spinBox.font
        property int maxCharCount: prefix.length + suffix.length + Math.ceil(Math.log(control.maximumValue) / Math.log(10))

        FontMetrics {
            id: fontMetrics
            font: font
        }

        font {
            family: fontStyle.family
            bold: fontStyle.bold
            italic: fontStyle.italic
            pixelSize: fontStyle.size
        }

        textColor: fontStyle.color
        selectionColor: textColor
        selectedTextColor: Style.spinBox.selectedTextColor

        background: Item {
            implicitHeight: fontStyle.size * 1.5
            implicitWidth: (maxCharCount + 1) * fontMetrics.maximumCharacterWidth + Style.spacing/2
        }

        // increment component
        incrementControl: SpinBoxControl {
            increment: true
        }
        decrementControl: SpinBoxControl {
            increment: false
        }
    }
}
