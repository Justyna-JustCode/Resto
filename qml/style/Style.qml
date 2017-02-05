/********************************************
**
** Copyright 2016 JustCode Justyna Kulinska
**
** This file is part of Resto.
**
** Resto is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** any later version.
**
** Resto is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Resto; if not, write to the Free Software
** Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
**
********************************************/

pragma Singleton
import QtQuick 2.5
import "."
import "helpers"

QtObject {
    id: style

    property color mainColor: ColorPallete.mainColor
    onMainColorChanged: {
        ColorPallete.mainColor = mainColor;
    }

    readonly property int margins: 20
    readonly property int smallMargins: 10
    readonly property int spacing: 10

    readonly property var background: QtObject {
        readonly property string color: ColorPallete.secondaryLightColor
        readonly property string image: "qrc:/resources/images/background.png"
        readonly property real opacity: 0.8
        readonly property color borderColor: ColorPallete.secondaryDarkColor
        readonly property int borderWidth: 3
    }
    readonly property var decorative: QtObject {
        readonly property string image: "qrc:/resources/images/pattern.png"
        readonly property string imageColor: "qrc:/resources/images/pattern-color.png"
        readonly property color color: ColorPallete.mainColor
    }

    readonly property var font: QtObject {
        readonly property var text: StyleFont {}
        readonly property var smallerText: StyleFont {
            size: style.font.text.size*0.9
        }
        readonly property var smallerHeader: StyleFont {
            size: style.font.smallerText.size
            bold: true
            capitalization: Font.SmallCaps
        }
        readonly property var textButton: StyleFont {
            bold: true
            capitalization: Font.SmallCaps
        }
        readonly property var imageButton: StyleFont {
            size: style.font.text.size*1.3
            capitalization: Font.SmallCaps
        }
        readonly property var imageButtonSmall: StyleFont {
            size: style.font.text.size*0.7
            capitalization: Font.SmallCaps
        }
        readonly property var imageButtonSmallest: StyleFont {
            size: style.font.text.size*0.55
            capitalization: Font.SmallCaps
        }
        readonly property var title: StyleFont {
            size: style.font.text.size*1.2
            bold: true
            color: ColorPallete.mainColor
        }
        readonly property var formHeader: StyleFont {
            capitalization: Font.SmallCaps
            bold: true
        }
        readonly property var formLabel: StyleFont {
            capitalization: Font.SmallCaps
        }
    }

    readonly property var timeBar: QtObject {
        readonly property color color: ColorPallete.mainColor
        readonly property color backgroundColor: ColorPallete.secondaryLightColor
        readonly property color secondaryColor: Qt.darker(color, 1.5)

        readonly property var font: StyleFont {
            color: ColorPallete.secondaryLightColor
            size: 0.8*style.font.text.size
            bold: true
        }

        readonly property real gradientFactor: 1.25
    }

    readonly property var tabView: QtObject {
        readonly property color borderColor: ColorPallete.mainColor
        readonly property int borderWidth: 1

        readonly property var activeFont: StyleFont {
            bold: true
            color: ColorPallete.mainColor
        }
        readonly property var inactiveFont: StyleFont {
            bold: true
            color: ColorPallete.secondaryDarkColor
        }
    }
    readonly property var colorPicker: QtObject {
        readonly property color activeColor: ColorPallete.secondaryDarkColor
        readonly property color inactiveColor: ColorPallete.secondaryLightColor

        readonly property int activeBorderWidth: 2
        readonly property int inactiveBorderWidth: 1
        readonly property int itemSize: 20
    }
    readonly property var switchControl: QtObject {
        readonly property color handleColor: ColorPallete.mainColor
        readonly property color backgroundColor: ColorPallete.secondaryLightColor
        readonly property int borderWidth: 2

        readonly property var font: StyleFont {
            size: 0.85*style.font.text.size
            bold: true
            capitalization: Font.SmallCaps
            color: switchControl.backgroundColor
        }
    }
    readonly property var spinBox: QtObject {
        readonly property var font: StyleFont {
            size: 0.85*style.font.text.size
            bold: true
            capitalization: Font.SmallCaps
            color: ColorPallete.mainColor
        }
        readonly property color selectedTextColor: ColorPallete.secondaryLightColor

        readonly property string incrementImage: "qrc:/resources/images/inc.png"
        readonly property string decrementImage: "qrc:/resources/images/dec.png"
    }
    readonly property var textBox: QtObject {
        readonly property var font: style.font.smallerFont
        readonly property color backgroundColor: ColorPallete.secondaryLightColor
        readonly property color borderColor: ColorPallete.secondaryDarkColor
        readonly property int borderWidth: 1
    }
}
