import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"

CustomDialog {
    id: breakRequestDialog

    signal accept()
    signal skip()

    title: qsTr("Time for finish!")
    description: qsTr("You should finish your work.")

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Ignore")

            onClicked: {
                skip();
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
