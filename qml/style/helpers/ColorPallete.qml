pragma Singleton
import QtQuick 2.5

QtObject {
    id: style

    property color mainColor: controller.settings.applicationColor
    readonly property color secondaryLightColor: "white"
    readonly property color secondaryDarkColor: "#1E1E1E"
}
