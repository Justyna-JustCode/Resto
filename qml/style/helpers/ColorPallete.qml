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

pragma Singleton
import QtQuick 2.12

QtObject {
    id: style

    readonly property var availableApplicationColors:         ["#19886F", "#EC811B", "#682C90", "#C0159B", "#008000", "#0958EC", "#666666"]
    readonly property var adjacentApplicationColorsPrimary:   ["#49B421", "#EC2F1B", "#473494", "#6B1FB4", "#649500", "#00EAD1", "#666666"]
    readonly property var adjacentApplicationColorsSecondary: ["#234F8B", "#ECAB1B", "#A82C7A", "#EF1A44", "#006060", "#380BED", "#525252"]
    readonly property var complementaryApplicationColors:     ["#D36927", "#147E91", "#D7D438", "#C1F41B", "#A00000", "#FFA500", "#888888"]

    property int mainColorIndex: controller.settings.applicationColorIndex
    property color mainColor: availableApplicationColors[mainColorIndex]
    readonly property color secondaryLightColor: "white"
    readonly property color secondaryDarkColor: "#1E1E1E"

    readonly property color shadowColor: "#88000000"
}
