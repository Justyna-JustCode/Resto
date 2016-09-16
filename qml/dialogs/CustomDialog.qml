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
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"
import "../components/helpers"
import "../style"

Window {
    id: dialog
    property int minWidth: 200
    property int minHeight: 100
    property string description: ""
    property alias image: imageItem
    property ObjectModel buttons
    property alias additionalContent: additionalContentItem

    signal showing
    signal hiding

    flags: Qt.Dialog | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal

    x: Screen.width/2 - width/2
    y: Screen.height/2 - height/2

    width: Math.max(minWidth, content.implicitWidth) + 2*Style.margins
    height: Math.max(minHeight, content.implicitHeight) + 2*Style.margins

    onVisibleChanged: {
        if (visible) {
            showing();
        }
        else {
            hiding();
        }
    }

    Background {
        border.color: Style.background.borderColor
        border.width: Style.background.borderWidth

        MouseArea {
            property var startPos

            anchors.fill: parent

            onPressed: {
                // remember starting position
                startPos = Qt.point(mouse.x, mouse.y)
            }

            onPositionChanged: {
                // count difference
                var difference = Qt.point(mouse.x - startPos.x,
                                          mouse.y - startPos.y);

                // update position
                dialog.x += difference.x;
                dialog.y += difference.y;
            }
        }
    }

    GridLayout {
        id: content
        anchors {
            fill: parent
            margins: Style.margins
        }

        columns: 2
        columnSpacing: Style.spacing

        Label {
            fontStyle: Style.font.title
            text: title
        }
        LayoutImage {
            id: imageItem

            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight
        }

        Label {
            Layout.columnSpan: 2
            text: description
        }

        GridLayout {
            Layout.columnSpan: 2
            Layout.fillWidth: additionalContentItem.fillWidth
            Layout.fillHeight: additionalContentItem.fillHeight

            Layout.preferredWidth: additionalContentItem.preferredWidth
            Layout.preferredHeight: additionalContentItem.preferredHeight

            Layout.alignment: additionalContentItem.alignment

            LayoutItem {
                id: additionalContentItem

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

        }

        Spacer {}

        RowLayout {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignCenter

            Repeater {
                model: buttons
            }
        }
    }
}
