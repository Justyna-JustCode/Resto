import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"
import "subitems"

CustomDialog {
    title: qsTr("Settings")

    image.source: "qrc:/resources/images/settings.png"

    function save() {
        for (var i=0; i<tabView.count; ++i) {
            tabView.getTab(i).active = true;
            tabView.getTab(i).item.save();
        }
    }
    function discard() {
        for (var i=0; i<tabView.count; ++i) {
            tabView.getTab(i).active = true;
            tabView.getTab(i).item.discard();
        }
    }

    additionalContent: TabView {
        id: tabView
        Layout.fillWidth: true

        Tab {
            title: "View"

            VisualSettings {}
        }
        Tab {
            title: "Logic"

            LogicSettings {}
        }
    }


    buttons: ObjectModel {
        TextButton {
            text: qsTr("Apply")

            onClicked: {
                save();
                close();
            }
        }
        TextButton {
            text: qsTr("Cancel")

            onClicked: {
                discard();
                close();
            }
        }
    }
}
