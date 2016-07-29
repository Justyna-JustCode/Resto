import QtQuick 2.5
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

    // load and save main window position and size
    Component.onCompleted: {
        width = controller.settings.windowSize.width
        height = controller.settings.windowSize.height
        x = controller.settings.windowPosition.x
        y = controller.settings.windowPosition.y
    }

    onWidthChanged: {
        controller.settings.windowSize.width = width;
    }
    onHeightChanged: {
        controller.settings.windowSize.height = height;
    }

    onXChanged: {
        controller.settings.windowPosition.x = x;
    }
    onYChanged: {
        controller.settings.windowPosition.y = y;
    }
    // ----------------------------------------------

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
    SettingsDialog {
        id: settingsDialog
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

    // small buttons
    RowLayout {
        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        ImageButton {
            styleFont: Style.font.imageButtonSmall
            type: "settings"
            tooltip: qsTr("Change settings")

            onClicked: settingsDialog.show()
        }
        ImageButton {
            styleFont: Style.font.imageButtonSmall
            type: "about"
            tooltip: qsTr("About resto")

            onClicked: aboutDialog.show()
        }
    }

}

