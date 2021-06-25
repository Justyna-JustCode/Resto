/********************************************
**
** Copyright 2021 Justyna JustCode
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
import QtGraphicalEffects 1.0
import "../../style"
import "../"

Item {
    property alias label: label

    implicitHeight: label.implicitHeight
    implicitWidth: label.implicitWidth

    CustomLabel {
        id: label

        width: parent.width
        height: parent.height
    }
    BarTextGradient {
        source: label
        value: Math.min(Math.max((progress.width - parent.x), 0.0) / width, 1.0)
    }
}
