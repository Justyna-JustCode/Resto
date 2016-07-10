import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQml.Models 2.2
import "../components"

CustomDialog {
    id: breakDialog

    signal endBreak();

    onShowing: {
        endButton.text = qsTr("Ignore");
    }

    title: qsTr("Time for a break!")
    description: qsTr("Break time:")

    image.source: "qrc:/resources/images/break.png"
    image.scale: 0.85
    image.data: PropertyAnimation {
        loops: Animation.Infinite
        running: true

        target: image
        property: "rotation"
        from: 0; to: 360;
        duration: 3000
        easing.type: Easing.InBounce
    }

    buttons: ObjectModel {
        TextButton {
            id: endButton

            onClicked: {
                endBreak();
                close();
            }
        }
    }

    additionalContent: TimeProgressBar {
        Layout.fillWidth: true

        maxValue: controller.settings.breakDuration
        value: controller.timer.elapsedBreakDuration
    }

    Connections {
        target: controller

        onBreakEndRequest: {
            endButton.text = qsTr("Ok");
        }
    }
}

