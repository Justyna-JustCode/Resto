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
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import "../components"
import "subitems"

CustomDialog {
    title: qsTr("Settings")

    image.source: "qrc:/resources/images/settings.png"

    function save() {
        for (var i=0; i<tabView.count; ++i) {
            tabView.getTab(i).save();
        }
    }
    function discard() {
        for (var i=0; i<tabView.count; ++i) {
            tabView.getTab(i).discard();
        }
    }

    additionalContent.data: TabView {
        id: tabView

        tabNames: [ qsTr("Behaviour"), qsTr("General"), qsTr("Appearance") ]

        TimesSettings {}
        LogicSettings {}
        VisualSettings {}
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
