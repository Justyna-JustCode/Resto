import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"
import "/js/resourceInfo.js" as ResourceInfo

CustomDialog {
    property string aboutMessage: authorMessage + "<br/><br/>" + resourcesMessage
    property string authorMessage: qsTr("<b>Author:</b><br/>
                                         <a href=\"http://justcode.com\">JustCode</a>")
    property string resourcesMessage: qsTr("<b>Resources:</b><br/>") + ResourceInfo.getInfo()

    signal accept()
    signal postpone()
    signal skip()

    title: qsTr("About Resto")
    description: aboutMessage

    image.source: "qrc:/resources/images/logo.png"
    image.scale: 0.8

    buttons: ObjectModel {
        TextButton {
            text: qsTr("Ok")

            onClicked: {
                close();
                accept();
            }
        }
    }
}
