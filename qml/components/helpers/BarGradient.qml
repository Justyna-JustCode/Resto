import QtQuick 2.0
import "../../style"

Gradient {
    id: gradient

    property string color

    GradientStop { position: 0.0; color: Qt.darker(gradient.color, Style.timeBar.gradientFactor) }
    GradientStop { position: 0.35; color: Qt.darker(gradient.color, Style.timeBar.gradientFactor) }
    GradientStop { position: 0.65; color: gradient.color }
    GradientStop { position: 1.0; color: gradient.color }
}
