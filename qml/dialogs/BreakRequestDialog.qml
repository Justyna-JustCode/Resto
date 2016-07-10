import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"

CustomDialog {
    id: breakRequestDialog

    signal accept()
    signal postpone()
    signal skip()

    title: qsTr("Time for a break!")
    description: qsTr("You should take a break.")

    image.source: "qrc:/resources/images/break.png"
    image.data: SequentialAnimation {
        loops: Animation.Infinite
        running: true

        PropertyAnimation { target: image; property: "scale"; from: 0.7; to: 1; duration: 500; easing.type: Easing.InBounce }
        PropertyAnimation { target: image; property: "scale"; from: 1; to: 0.7; duration: 500; easing.type: Easing.OutBounce }
    }

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Ignore")

            onClicked: {
                skip();
                close();
            }
        }
        TextButton {
            text: qsTr("Retry")

            onClicked: {
                postpone();
                close();
            }
        }
        TextButton {
            text: qsTr("Ok")

            onClicked: {
                accept();
                close();
            }
        }
    }
}
