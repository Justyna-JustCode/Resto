import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import "../components"

CustomDialog {
    id: breakDialog

    signal endBreak();

    width: content.implicitWidth
    height: content.implicitHeight

    onVisibleChanged: {
        if (visible) {
            endButton.text = "Ignore";
        }
    }

    title: qsTr("Time for a break!")

    ColumnLayout {
        id: content
        width: parent.width

        Text {
            text: qsTr("Break time:")
        }
        TimeProgressBar {
            Layout.minimumWidth: 200

            maxValue: controller.settings.breakDuration
            value: controller.breakTime
        }

        Button {
            id: endButton
            Layout.alignment: Qt.AlignVCenter

            text: "Ignore"
            onClicked: {
                endBreak();
                close();
            }
        }
    }

    Connections {
        target: controller

        onEndOfBreakRequest: {
            endButton.text = "Ok";
        }
    }
}

