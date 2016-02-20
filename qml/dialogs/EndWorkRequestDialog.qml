import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

CustomDialog {
    id: breakRequestDialog

    signal accept()
    signal skip()

    width: content.implicitWidth
    height: content.implicitHeight

    title: qsTr("Time for finish!")

    ColumnLayout {
        id: content
        Text {
            Layout.alignment: Qt.AlignVCenter

            text: qsTr("You should finish your work for today.")
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
                text: "Ok"
                onClicked: {
                    accept();
                    close();
                }
            }
        }
    }
}
