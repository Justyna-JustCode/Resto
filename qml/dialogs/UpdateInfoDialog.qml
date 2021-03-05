/********************************************
**
** Copyright 2017 Justyna JustCode
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
import "../style"
import "../components"

CustomDialog {
    signal acceptDownload()
    signal acceptUpdate()
    signal postpone()
    signal skip()

    title: qsTr("Update available!")
    description: qsTr("There is a new version (") + controller.updater.newestVersion + qsTr(") available.");

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Download")

            visible: !controller.updater.updatePossible

            onClicked: {
                close();
                acceptDownload();
            }
        }
        TextButton {
            text: qsTr("Update")

            visible: controller.updater.updatePossible

            onClicked: {
                close();
                acceptUpdate();
            }
        }
        TextButton {
            text: qsTr("Postpone")

            onClicked: {
                close();
                postpone();
            }
        }
        TextButton {
            text: qsTr("Skip")

            onClicked: {
                close();
                skip();
            }
        }
    }

    additionalContent.fillWidth: true
    additionalContent.data: ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
        }

        Spacer {}
        ClickableLabel {
            fontStyle: Style.font.smallerHeader

            text: qsTr("Show") + " " + (releaseNotesBox.visible ? (qsTr("less") + " <") : (qsTr("more") + " >") )

            onClicked: releaseNotesBox.visible = !releaseNotesBox.visible;
        }

        TextBox {
            id: releaseNotesBox
            Layout.fillWidth: true

            visible: false

            text: controller.updater.releaseNotes
        }
    }
}
