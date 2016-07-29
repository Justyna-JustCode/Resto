import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"

CustomDialog {
    signal accept()
    signal skip()

    title: qsTr("Time for finish!")
    description: qsTr("You should finish your work.")

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Ignore")

            onClicked: {
                close();
                skip();
            }
        }
        TextButton {
            text: qsTr("Ok")

            onClicked: {
                close();
                accept();
            }
        }
    }
}
