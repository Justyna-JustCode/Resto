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

import QtQuick 2.14
import QtQuick.Layouts 1.3
import "../style"
import "helpers"

Item {
    id: root
    property alias editMode: editMode

    property int minValue: 0
    property int maxValue: 100
    property int value: 0

    implicitHeight: textLabel.label.font.pixelSize * 1.4
    implicitWidth: 200

    signal timeEdited(int newValue)

    ValueEditMode {
        id: editMode

        focusItem: textEditableInput
        autoConfirm: false

        onActiveEditChanged: {
            textEditableInput.text = textLabel.label.text.replace(/ /g, '')
        }

        onConfirmChanges: {
            var intermediateInput = textEditableInput.text.length != textEditableInput.timeInputMask.length;
            if (!intermediateInput) {
                timeEdited(d.deFormatTime(textEditableInput.text))

                // we need to change activeEdit manually because autoConfirm is set to false
                // this is done to avoid finishing edition for intermidate input
                activeEdit = false
            }
        }
    }

    QtObject {
        id: d

        property bool isExcess: value > maxValue
        property real valuePercent: isExcess ? maxValue/value : value/maxValue

        function formatTime(timeSecs) {
            var hours, mins, secs
            secs = timeSecs%60
            mins = (Math.floor(timeSecs/60))%60
            hours = Math.floor( (Math.floor(timeSecs/60))/60 )

            var hoursStr, minsStr, secsStr
            secsStr = secs > 9 ? secs : '0' + secs
            minsStr = mins > 9 ? mins : '0' + mins
            hoursStr = hours > 9 ? hours : '0' + hours

            return hoursStr + ':' + minsStr + ':' + secsStr
        }

        function deFormatTime(timeStr)
        {
            var splitted = timeStr.split(':')

            var hours = parseInt(splitted[0])
            var mins = parseInt(splitted[1])
            var secs = parseInt(splitted[2])

            return hours * 60 * 60 + mins * 60 + secs
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent

        color: Style.timeBar.backgroundColor
        border.color: Style.timeBar.color
        border.width: 1
    }
    Rectangle {
        id: progress
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        gradient: BarGradient { color: Style.timeBar.color }

        width: d.valuePercent * parent.width
    }
    Rectangle {
        id: excess
        anchors {
            left: progress.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        visible: d.isExcess

        gradient: BarGradient { color: Style.timeBar.secondaryColor }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 1

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            BarGradientLabel {
                id: textLabel
                anchors.fill: parent
                visible: !editMode.activeEdit

                label {
                    fontStyle: Style.timeBar.font

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight

                    elide: Text.ElideRight

                    text: d.formatTime(value)
                }

            }

            LabelInput {
                id: textEditableInput

                /* we need this property to compare in onAccepted slot
                 * it seems that inputMask is extended with additional characters after creation
                 */
                property string timeInputMask: "99:99:99"

                anchors.fill: parent
                visible: editMode.activeEdit

                cursorVisible: true

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight

                fontStyle: Style.spinBox.font
                color: Style.highlightedApplicationColors[Style.mainColorIndex]

                inputMask: timeInputMask
                validator: RegularExpressionValidator {
                    regularExpression: /^([0-9][0-9]|[0-9] |  ):([0-5][0-9]|[0-5] |  ):([0-5][0-9]|[0-5] |  )$/
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: editMode.enabled
                propagateComposedEvents: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onDoubleClicked:
                {
                    editMode.edit()
                }

                onClicked:
                {
                    if(mouse.button === Qt.RightButton)
                    {
                        editMode.decline()
                    }
                }
            }
        }

        BarGradientLabel {
            Layout.fillHeight: true
            Layout.preferredHeight: 0
            Layout.preferredWidth: implicitWidth

            label {
                fontStyle: Style.timeBar.font

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                text: "/"
            }
        }

        BarGradientLabel {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 0
            Layout.preferredWidth: 0

            label {
                fontStyle: Style.timeBar.font

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                elide: Text.ElideRight

                text: d.formatTime(maxValue)
            }
        }
    }
}

