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
import QtQuick.Controls 2.5
import "../components"
import "../components/helpers"
import "../style"
import "../utils"

SpinBox {
    id: spinBox
    property string prefix
    property string suffix

    property int maxCharCount: prefix.length + suffix.length + charCount(to)
    property real maxWidth: UiUtils.averageTextWidth(d.fontMetrics, maxCharCount + 1) + Style.spacing + up.implicitIndicatorWidth

    QtObject {
        id: d

        property var fontMetrics: FontMetrics {
            font: font
        }
    }

    textFromValue: function(value) {
        return prefix + value + suffix
    }

    valueFromText: function(text) {
        return text.substring(prefix.length, text.length - suffix.length)
    }

    contentItem: LabelInput {
        fontStyle: Style.spinBox.font
        text: spinBox.textFromValue(spinBox.value, spinBox.locale)

        readOnly: !spinBox.editable
        validator: spinBox.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly

        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }

    background: Item {}

    up.indicator: SpinBoxControl {
        anchors {
            right: parent.right
            top: mirrored ? undefined : parent.top
            bottom: mirrored ? parent.bottom : undefined
        }
        height: 0.45 * parent.height
        increment: !mirrored
    }
    down.indicator: SpinBoxControl {
        anchors {
            right: parent.right
            top: mirrored ? parent.top : undefined
            bottom: mirrored ? undefined : parent.bottom
        }
        height: 0.45 * parent.height
        increment: mirrored
    }
}
