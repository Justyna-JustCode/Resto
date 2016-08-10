import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"
import "/js/resourceInfo.js" as ResourceInfo

CustomDialog {
    property string aboutMessage: authorMessage + "<br/><br/>" + resourcesMessage
    property string authorMessage: qsTr("<b>Author:</b><br/>") +
                                         "<a href=\"http://" + app.organizationDomain + "\">" + app.organizationName + "</a>"
    property string resourcesMessage: qsTr("<b>Resources:</b><br/>") + ResourceInfo.getInfo()

    signal accept()
    signal postpone()
    signal skip()

    title: qsTr("About") + " " + app.applicationName + "\n(" +qsTr("ver.") + " " + app.applicationVersion + ")"
    description: aboutMessage

    image.source: "qrc:/resources/images/org-logo.png"
    image.preferredWidth: 175
    image.preferredHeight: image.paintedHeight
    image.fillMode: Image.PreserveAspectFit
    image.mipmap: true

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Ok")

            onClicked: {
                close();
                accept();
            }
        }
    }

    additionalContent.alignment: Qt.AlignHCenter
    additionalContent.data: Image {
        height: 40
        mipmap: true
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter

        source: "qrc:/resources/images/qt-logo.png"
    }
}