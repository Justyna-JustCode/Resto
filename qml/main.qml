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

    width: 300
    height: 100

    Connections {
        target: controller

        onBreakRequest: {
            breakRequestDialog.show();
        }
        onEndOfWorkRequest: {
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
            controller.startWork(true);
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

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            RowLayout {
                Button {
                    visible: controller.state == Controller.Pause || controller.state == Controller.Off
                    text: qsTr("Play")

                    onClicked: {
                        controller.start()
                    }
                }
                Button {
                    visible: controller.state != Controller.Off
                    text: qsTr("Stop")

                    onClicked: {
                        controller.stop()
                    }
                }
                Button {
                    visible: controller.state == Controller.Work
                    text: qsTr("Pause")

                    onClicked: {
                        controller.pause()
                    }
                }
                Button {
                    visible: controller.state == Controller.Work
                    text: qsTr("Break")

                    onClicked: {
                        controller.startBreak()
                        breakDialog.show();
                    }
                }
            }
            RowLayout {
                Text {
                    text: qsTr("Next break:")
                }
                TimeProgressBar {
                    Layout.fillWidth: true

                    maxValue: controller.settings.breakInterval
                    value: controller.timeToBreak
                }
            }
            RowLayout {
                Text {
                    text: qsTr("Work time:")
                }
                TimeProgressBar {
                    Layout.fillWidth: true

                    maxValue: controller.settings.workTime
                    value: controller.workTime
                }
            }

        }
    }
}

