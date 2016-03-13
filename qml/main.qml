import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import Resto.Types 1.0
import "components"
import "dialogs"

Window {
    visible: true

    width: 400
    height: 200

    Background {
        anchors.fill: parent
    }

    Connections {
        target: controller

        onBreakStartRequest: {
            breakRequestDialog.show();
        }
        onWorkEndRequest: {
            endWorkRequestDialog.show();
        }
    }

    BreakRequestDialog {
        id: breakRequestDialog

        onAccept: {
            controller.startBreak();
            breakDialog.show();
        }
        onPostpone: {
            controller.postponeBreak();
        }
        onSkip: {
            controller.startWork();
        }
    }
    BreakDialog {
        id: breakDialog

        onEndBreak: {
            controller.startWork();
        }
    }
    EndWorkRequestDialog {
        id: endWorkRequestDialog

        onAccept: {
            controller.stop();
        }
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 30

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            RowLayout {
                ImageButton {
                    scale: 0.8

                    type: "play"
                    tooltip: qsTr("Play")
                    visible: controller.state == Controller.Paused || controller.state == Controller.Off

                    onClicked: {
                        controller.start()
                    }
                }
                ImageButton {
                    scale: 0.8

                    type: "break"
                    tooltip: qsTr("Break")
                    visible: controller.state == Controller.Working

                    onClicked: {
                        controller.startBreak()
                        breakDialog.show();
                    }
                }
                ImageButton {
                    scale: 0.8

                    type: "pause"
                    tooltip: qsTr("Pause")
                    visible: controller.state == Controller.Working

                    onClicked: {
                        controller.pause()
                    }
                }
                ImageButton {
                    scale: 0.8

                    type: "stop"
                    tooltip: qsTr("Stop")
                    visible: controller.state == Controller.Working

                    onClicked: {
                        controller.stop()
                    }
                }
            }
            GridLayout {
                Layout.fillWidth: true
                columns: 2

                Label {
                    text: qsTr("Next break:")
                }
                TimeProgressBar {
                    Layout.fillWidth: true

                    maxValue: controller.settings.breakInterval
                    value: controller.timer.elapsedWorkPeriod
                }
                Label {
                    text: qsTr("Work time:")
                }
                TimeProgressBar {
                    Layout.fillWidth: true

                    maxValue: controller.settings.workTime
                    value: controller.timer.elapsedWorkTime
                }
            }

        }
    }
}

