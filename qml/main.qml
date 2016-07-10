import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import Resto.Types 1.0
import "components"
import "dialogs"
import "style"

Window {
    visible: true

    width: 400
    height: 200

    Background {
        Decorative {}
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

    // dialogs - TODO: additional component
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
    AboutDialog {
        id: aboutDialog
    }

    // content
    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 30
        spacing: 0

        RowLayout {
            ImageButton {
                type: "play"
                tooltip: qsTr("Play")

                visible: controller.state != Controller.Working

                onClicked: {
                    controller.start()
                }
            }
            ImageButton {
                type: "break"
                tooltip: qsTr("Break")

                visible: controller.state == Controller.Working

                onClicked: {
                    controller.startBreak()
                    breakDialog.show();
                }
            }
            ImageButton {
                type: "pause"
                tooltip: qsTr("Pause")

                visible: controller.state == Controller.Working

                onClicked: {
                    controller.pause()
                }
            }
            ImageButton {
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

    // about button
    ImageButton {
        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        styleFont: Style.font.imageButtonSmall
        type: "about"
        tooltip: qsTr("About resto")

        onClicked: aboutDialog.show()
    }
}

