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
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"
import "subitems"

CustomDialog {
    title: qsTr("Settings")

    image.source: "qrc:/resources/images/settings.png"

    function save() {
        for (var i=0; i<tabView.count; ++i) {
            tabView.getTab(i).active = true;
            tabView.getTab(i).item.save();
        }
    }
    function discard() {
        for (var i=0; i<tabView.count; ++i) {
            tabView.getTab(i).active = true;
            tabView.getTab(i).item.discard();
        }
    }

    additionalContent.data: TabView {
        id: tabView

        onCountChanged: {
            // calculate max size of tabs
            var maxWidth = 0; var maxHeight = 0;
            for (var i=0; i<count; ++i) {
                tabView.getTab(i).active = true;

                if (getTab(i).implicitWidth > maxWidth)
                    maxWidth = getTab(i).implicitWidth;

                if (getTab(i).implicitHeight > maxHeight)
                    maxHeight = getTab(i).implicitHeight;

                tabView.getTab(i).active = false;
            }
            implicitWidth = Math.max(implicitWidth, maxWidth);
            implicitHeight = Math.max(implicitHeight, maxHeight + tabsHeight);
        }

        Tab {
            title: qsTr("Behaviour")

            LogicSettings {}
        }
        Tab {
            title: qsTr("Appearance")

            VisualSettings {}
        }
    }

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Apply")

            onClicked: {
                close();
                save();
            }
        }
        TextButton {
            text: qsTr("Cancel")

            onClicked: {
                close();
                discard();
            }
        }
    }
}
