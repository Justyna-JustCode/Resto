import QtQuick 2.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQml.Models 2.2
import "../components"
import "../components/helpers"
import "../style"

Window {
    property int minWidth: 200
    property int minHeight: 100
    property string description: ""
    property alias image: imageItem
    property ObjectModel buttons
    property alias additionalContent: additionalContentItem.data

    signal showing
    signal hiding

    flags: Qt.Dialog | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal

    x: Screen.width/2 - width/2
    y: Screen.height/2 - height/2

    width: Math.max(minWidth, content.implicitWidth) + 2*Style.margins
    height: Math.max(minHeight, content.implicitHeight) + 2*Style.margins

    onVisibleChanged: {
        if (visible) {
            showing();
        }
        else {
            hiding();
        }
    }

    Background {
        border.color: Style.background.borderColor
        border.width: Style.background.borderWidth
    }

    GridLayout {
        id: content
        anchors {
            fill: parent
            margins: Style.margins
        }

        columns: 2
        columnSpacing: Style.spacing

        Label {
            fontStyle: Style.font.title
            text: title
        }
        LayoutImage {
            id: imageItem

            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight
        }

        Label {
            Layout.columnSpan: 2
            text: description
        }

        GridLayout {
            id: additionalContentItem
            Layout.columnSpan: 2
        }

        Spacer {}

        RowLayout {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignCenter

            Repeater {
                model: buttons
            }
        }
    }
}
