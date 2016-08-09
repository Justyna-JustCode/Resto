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

        onCountChanged: {
            // calculate max size of tabs
            var maxWidth = 0; var maxHeight = 0;
            for (var i=0; i<count; ++i) {
                tabView.getTab(i).active = true;

                if (getTab(i).implicitWidth > maxWidth)
                    maxWidth = getTab(i).implicitWidth;

                if (getTab(i).implicitHeight > maxHeight)
                    maxHeight = getTab(i).implicitHeight;

                tabView.getTab(i).active = false;
            }
            implicitWidth = Math.max(implicitWidth, maxWidth);
            implicitHeight = Math.max(implicitHeight, maxHeight + tabsHeight);
        }

        Tab {
            title: "Behavior"

            LogicSettings {}
        }
        Tab {
            title: "Appearance"

            VisualSettings {}
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
