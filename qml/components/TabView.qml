import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../style"

TabView {
    style: TabViewStyle {
        tabsAlignment: Qt.AlignHCenter

        frame: Rectangle {
            border.width: Style.tabView.borderWidth
            border.color: Style.tabView.borderColor

            color: "transparent"
        }
        frameOverlap: Style.tabView.borderWidth

        tab: TextButton {
            text: styleData.title
            styleFont: styleData.selected ? Style.tabView.activeFont : Style.tabView.inactiveFont

            onClicked: {
                control.currentIndex = styleData.index
            }
        }
    }
}
