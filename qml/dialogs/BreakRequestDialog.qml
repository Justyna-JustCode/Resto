import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

CustomDialog {
    id: breakRequestDialog

    signal accept()
    signal postpone()
    signal skip()

    width: content.implicitWidth
    height: content.implicitHeight

    title: qsTr("Time for a break!")

    ColumnLayout {
        id: content
        Text {
            Layout.alignment: Qt.AlignVCenter

            text: qsTr("You should take a break.")
        }
        RowLayout {
            Layout.alignment: Qt.AlignVCenter

            Button {
                text: "Ignore"
                onClicked: {
                    skip();
                    close();
                }
            }
            Button {
                text: "Retry"
                onClicked: {
                    postpone();
                    close();
                }
            }
            Button {
                text: "Ok"
                onClicked: {
                    accept();
                    close();
                }
            }
        }
    }
}
